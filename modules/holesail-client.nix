### Holesail client module.  WORK IN PROGRESS ###############
{
  config,
  lib,
  pkgs ? import <nixpkgs> {},
  ...
}:
let
  holesail = (import ./holesail.nix {inherit pkgs;});
  cfg = config.services.holesail-client;
in
{
  options.services.holesail-client = lib.mkOption {
    type = lib.types.attrsOf (lib.types.submodule {
      options = {
        enable = lib.mkEnableOption "Enable this Holesail client instance.";
        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Host address to use for this Holesail client instance.";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 8989;
          description = "The port which this Holesail client instance should use.";
        };
        udp = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable UDP instead of TCP.";
        };
        connection-string = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The connection string to the Holesail server. If empty, there will be an error.";
        };
      };
    });
    description = "Configure multiple Holesail client instances.";
    default = {};
  };

  config = lib.mkIf (lib.any (name: cfg.${name}.enable) (lib.attrNames cfg)) {
    systemd.services = lib.genAttrs (lib.attrNames cfg) (name: 
      let
        instanceCfg = cfg.${name};
      in
        lib.mkIf instanceCfg.enable {
          description = "Holesail client (${name})";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            ExecStart = ''${holesail}/bin/holesail \
              ${instanceCfg.connection-string} \
              --port ${toString instanceCfg.port} \
              --host ${instanceCfg.host} \
              ${if instanceCfg.udp then "--udp" else ""}
            '';
            Type = "simple";
            Restart = "always";
            RestartSec = "10";
          };
        }
    );
  };

  meta.maintainers = with lib.maintainers; [ jjacke13 ];
}
