# Holesail-nix
Holesail package for the Nix package manager

This is a build of the amazing Holesail.io for the Nix package manager

In NixOS or non-NixOS linux (but with Nix installed), run: 

- nix-build holesail.nix

If you have flakes enabled:

- nix build github:jjacke13/holesail-nix

If you want only the server or the client part of holesail:

- nix build github:jjacke13/holesail-nix/holesail-server
- nix build github:jjacke13/holesail-nix/holesail-client

Also available nix-shells with the above packages available:

- nix develop github:jjacke13/holesail-nix
- nix develop github:jjacke13/holesail-nix/holesail-server
- nix develop github:jjacke13/holesail-nix/holesail-client

For documentation on how to use Holesail, go to: https://github.com/holesail/holesail .

Notice: the MIT license here, refers to the code of this repository. License of the actual Holesail package is GPL3.0
