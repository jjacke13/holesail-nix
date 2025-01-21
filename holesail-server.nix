### Holesail Module.... hopefully ###############3
{
  config,
  lib,
  pkgs ? import <nixpkgs> {},
  ...
}:
let
  holesail = (import ./holesail.nix {inherit pkgs;});
  cfg = config.services.holesail-server;
in
{
  options.services.holesail-server = with lib; {
    enable = mkEnableOption "Holesail.... just magic...";

    port = mkOption {
      type = types.port;
      default = 8989;
      description = "The port which Holesail client should use";
    };

    #dataDirectory = mkOption {   ### Keep it for holesail filemanager for later
    #  type = types.path;
    #  default = "";
    #  example = "/mnt/podcasts";
    #  description = "Directory ";
    #};

    host = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = "Host address to use for Holesail client";
    };

    udp = mkOption {
      type = types.bool;
      default = false;
      description = "Enable UDP instead of TCP";
    };

    connector = mkOption {
      type = types.str;
      default = "";
      description = "The connection string that the Holesail server should use. If empty, a new, random connection string will be generated.";
    };

    public = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to announce the server to the DHT.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.holesail-server = {
      description = "Holesail";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = ''${holesail}/bin/holesail \
                    ${if cfg.connector == "" then "" else "--connector ${cfg.connector}"} \
                    --live ${toString cfg.port} \
                    --host ${cfg.host} \
                    ${if cfg.udp then "--udp" else ""} \
                    ${if cfg.public then "--public" else ""}
        '';
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ jjacke13 ];
}
