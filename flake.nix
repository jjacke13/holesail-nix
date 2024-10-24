{
    description = "A Nix flake for Holesail!!!";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    };

    outputs = { self, nixpkgs, ... }:
    let
        system = "aarch64-linux";
        pkgs = import nixpkgs {inherit system; };
    in 
    {
        packages = {
                holesail = ./holesail.nix ;
            };

    };
}
