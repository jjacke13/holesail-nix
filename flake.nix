{
  description = "Holesail";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }@inputs:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          holesail = import ./holesail.nix { inherit pkgs; };
          default = holesail;
        };
        devShells = {
          holesail = pkgs.mkShell {
            buildInputs = [ self.packages.${system}.default ];
          };
        };
        nixosModules = {
          holesail-client = import ./modules/holesail-client.nix;
          holesail-server = import ./modules/holesail-server.nix;
          holesail-filemanager = import ./modules/holesail-filemanager.nix;
          holesail = import ./modules/holesail.nix;
        };
      }
    );
}
