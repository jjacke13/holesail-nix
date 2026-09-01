# `holesailCpp` is threaded in by flake.nix: a NixOS module cannot reach a
# flake input on its own, and the C++ port is one. It stays optional so this
# file still works when imported by path — only `implementation = "cpp"` needs
# it, and that path explains itself rather than failing obscurely.
{ holesailCpp ? null }:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  holesail = (import ../holesail.nix {inherit pkgs;});
  cppPackage =
    if holesailCpp != null then holesailCpp
    else throw ''
      services.holesail-client: implementation = "cpp" needs the holesail-cpp
      package, which this module only receives when it is taken from the
      holesail-nix flake, e.g.

        imports = [ inputs.holesail.nixosModules.<system>.holesail-client ];

      Importing modules/holesail-client.nix by path gives you the JS package
      only. Set `package` explicitly if you need the C++ port that way.
    '';
  cfg = config.services.holesail-client;
in
{
  options.services.holesail-client = mkOption {
    # A function, so `package` can default off `implementation` in the same
    # submodule.
    type = types.attrsOf (types.submodule ({ config, ... }: {
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
        implementation = mkOption {
          type = types.enum [ "js" "cpp" ];
          default = "js";
          example = "cpp";
          description = ''
            Which holesail to run.

            `js` is the upstream Node implementation (the default, and what the
            Holesail project supports). `cpp` is holesail-cpp, an independent
            C++ port that speaks the same protocol — same connection strings,
            same key derivation, same DHT records — in roughly 3 MB of RSS
            instead of ~78 MB, with no Node runtime on the target. Worth it on
            constrained hardware; otherwise prefer `js`.

            This only picks the default for `package`; setting `package`
            directly still wins.
          '';
        };
        package = mkOption {
          type = types.package;
          default = if config.implementation == "cpp" then cppPackage else holesail;
          defaultText = literalExpression
            "the package matching `implementation` (JS holesail, or holesail-cpp)";
          description = ''
            The holesail package to run. Normally left alone — set
            `implementation` instead. Override this to pin a specific build;
            both CLIs take the same flags.
          '';
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
        log = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to enable logs of holesail.";
        };
      };
    }));
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
          path = [ instanceCfg.package ];
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
  };

  meta.maintainers = with maintainers; [ jjacke13 ];
}
