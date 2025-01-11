{
  description = "Holesail";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
        pack = self.packages.${system};
      in
      {
        packages = rec {
          holesail = import ./holesail.nix { inherit pkgs; };
          holesail-server = import ./holesail-server.nix { inherit pkgs; };
          holesail-client = import ./holesail-client.nix { inherit pkgs; };
          default = holesail;
        };
        devShells = {
          holesail = pkgs.mkShell {
            buildInputs = [ pack.default ];
          };
          holesail-server = pkgs.mkShell {
            buildInputs = [ pack.holesail-server ];
          };
          holesail-client = pkgs.mkShell {
            buildInputs = [ pack.holesail-client ];
          };
        };      
      }
    );
}
