{ config, pkgs, ... }:

{
  imports =
    [
      ./holesail-server.nix
      ./holesail-client.nix
      ./holesail-filemanager.nix
    ];

  environment.systemPackages = [
    (pkgs.callPackage ../holesail.nix { })
  ];
}
