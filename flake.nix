{
  description = "Holesail";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, systems, ... }@inputs:
  let
    pkgs = nixpkgs.legacyPackages;
    eachSystem = nixpkgs.lib.genAttrs (import systems);
  in
  {
    packages = eachSystem (system:{
      holesail = import ./holesail.nix { pkgs = pkgs.${system}; };
    });

  };

}
