{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./holesail-server.nix
      ./holesail-client.nix
      ./holesail-filemanager.nix
    ];

  environment.systemPackages = [
    (import ../holesail.nix { inherit pkgs; })
  ];
}
