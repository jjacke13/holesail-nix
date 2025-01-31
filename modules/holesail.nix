{ config, lib, ... }:

{
  imports =
    [ ./holesail-server.nix
      ./holesail-client.nix
      ./holesail-filemanager.nix
    ];
}