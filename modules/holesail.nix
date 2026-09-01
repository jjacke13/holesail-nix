# Aggregator: pulls in all three service modules at once.
#
# `holesailCpp` is threaded through to the client and server modules so their
# `implementation = "cpp"` option works; see those files for why a NixOS module
# cannot fetch a flake input itself. The filemanager is deliberately not given
# it — holesail-cpp does not implement `--filemanager`, so that service is
# JS-only by construction.
{ holesailCpp ? null }:
{ config, lib, pkgs, ... }:

{
  imports =
    [
      (import ./holesail-server.nix { inherit holesailCpp; })
      (import ./holesail-client.nix { inherit holesailCpp; })
      ./holesail-filemanager.nix
    ];

  environment.systemPackages = [
    (import ../holesail.nix {inherit pkgs;})
  ];
}
