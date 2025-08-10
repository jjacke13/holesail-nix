{ config
, lib
, pkgs
, ...
}:
with lib;
let
  holesail = pkgs.callPackage ../holesail.nix { };
  cfg = config.services.holesail-client;
in
{
  options.services.holesail-client = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        enable = mkEnableOption "Enable this Holesail client instance.";
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Host address to use for this Holesail client instance.";
        };
        port = mkOption {
          type = types.port;
          default = 8989;
          description = "The port which this Holesail client instance should use.";
        };
        udp = mkOption {
          type = types.bool;
          default = false;
          description = "Enable UDP instead of TCP.";
        };
        connection-string = mkOption {
          type = types.str;
          default = "";
          description = "The connection string to the Holesail server. If empty, there will be an error.";
        };
        connection-string-file = mkOption {
          type = types.str;
          default = "";
          description = "The path to a file containing the connection string to the Holesail server. If null, the connection-string option will be used.";
        };
      };
    });
    description = "Configure multiple Holesail client instances.";
    default = { };
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
        script = ''holesail \
              ${instanceCfg.connection-string} \
              $(cat ${instanceCfg.connection-string-file}) \
              --port ${toString instanceCfg.port} \
              --host ${instanceCfg.host} \
              ${if instanceCfg.udp then "--udp" else ""}
          '';
        serviceConfig.Type = "simple";
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = "10";
      }
    );
  };

  meta.maintainers = with maintainers; [ jjacke13 ];
}
