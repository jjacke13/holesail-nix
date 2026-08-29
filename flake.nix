{
  description = "Holesail";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    # C++ port, re-exported as packages.holesail-cpp. Deliberately NOT
    # `inputs.nixpkgs.follows = "nixpkgs"`: it pins its own nixpkgs for a
    # libuv version its DHT depends on, so let it keep the tree it was
    # tested against. Bump with: nix flake update holesail-cpp
    holesail-cpp.url = "github:jjacke13/holesail-cpp";
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
          holesail-cpp = inputs.holesail-cpp.packages.${system}.default;
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
