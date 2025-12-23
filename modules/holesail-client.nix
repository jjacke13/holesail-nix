{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  holesail = (import ../holesail.nix {inherit pkgs;});
  cfg = config.services.holesail-client;
in
{
  options.services.holesail-client = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        enable = mkEnableOption "Enable this Holesail client instance.";

        user = mkOption {
          description = "User that runs holesail";
          default = "holesail";
          type = types.str;
        };
        group = mkOption {
          description = "Group under which holesail runs.";
          default = "holesail";
          type = types.str;
        };
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host address to use for this Holesail client instance.";
        };
        port = mkOption {
          type = types.nullOr types.port;
          default = null;
          description = "The port which this Holesail client instance should use. It will be recognized automatically from the provided key,
            but if you want you can choose another. If null, holesail will auto-detect from the key.";
        };
        udp = mkOption {
          type = types.bool;
          default = false;
          description = "Enable UDP instead of TCP.";
        };
        key = mkOption {
          type = types.str;
          default = "";
          description = "The connection key of the Holesail server. If this and the key-file options are empty, there will be an error.";
        };
        key-file = mkOption {
          type = types.str;
          default = "";
          description = "The path to a file containing the key of the Holesail server. If null, the key option will be used.";
        };
        datadir = mkOption {
          type = types.str;
          default = "/var/lib/holesail";
          description = "Where Holesail should save the keys";
        };
        log = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable logs of holesail.";
        };
      };
    });
    description = "Configure multiple Holesail client instances.";
    default = {};
  };

  config = mkIf (any (name: cfg.${name}.enable) (attrNames cfg)) {
    systemd.services = genAttrs (attrNames cfg) (name: 
      let
        instanceCfg = cfg.${name};
      in
        mkIf instanceCfg.enable {
          description = "Holesail client (${name})";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          path = [ holesail ];
          script = let
            args = lib.concatStringsSep " " (lib.filter (x: x != "") [
              (if instanceCfg.key != "" then instanceCfg.key else "")
              (if instanceCfg.key-file != "" then "$(cat ${instanceCfg.key-file})" else "")
              (if instanceCfg.port != null then "--port ${toString instanceCfg.port}" else "")
              "--host ${instanceCfg.host}"
              (if instanceCfg.udp then "--udp" else "")
              (if instanceCfg.log then "--log" else "")
            ]);
          in ''
            holesail ${args}
          '';
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            RestartSec = "10";
            User = instanceCfg.user;
            Group = instanceCfg.group;
            ExecStartPost = "${pkgs.bash}/bin/bash -c '${
              if instanceCfg.key != "" then
                "echo -n \"${instanceCfg.key}\" > ${instanceCfg.datadir}/holesail-${name}-connection.key"
              else
                "cat ${instanceCfg.key-file} | tr -d \"\\n\" > ${instanceCfg.datadir}/holesail-${name}-connection.key"
            }'";
          };
        }
    );

    users.users = lib.mkIf (any (name: cfg.${name}.user == "holesail") (attrNames cfg)) {
      holesail = {
        isSystemUser = true;
        group = "holesail";
        home = "/var/lib/holesail";
      };
    };

    users.groups = lib.mkIf (any (name: cfg.${name}.group == "holesail") (attrNames cfg)) {
      holesail = { };
    };

    systemd.tmpfiles.rules =
      lib.unique (map (name:
        let instanceCfg = cfg.${name}; in
        "d ${instanceCfg.datadir} 0755 ${instanceCfg.user} ${instanceCfg.group} - -"
      ) (filter (name: cfg.${name}.enable && cfg.${name}.datadir == "/var/lib/holesail") (attrNames cfg)));

  };

  meta.maintainers = with maintainers; [ jjacke13 ];
}
