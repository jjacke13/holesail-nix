{
  description = "Holesail";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    pkgs = nixpkgs.legacyPackages;
    forAllSystems = f: {
      x86_64-linux = f "x86_64-linux";
      aarch64-linux = f "aarch64-linux";
    }; 
  in
  {
    packages = forAllSystems (system:{
      holesail = import ./holesail.nix { pkgs = pkgs.${system}; };
    }); 


  };

}
