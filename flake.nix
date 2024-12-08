{
  description = "Holesail";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    pkgs = nixpkgs.legacyPackages;
    forAllSystems = f: {
      x86_64-linux = f "x86_64-linux";
      aarch64-linux = f "aarch64-linux";
    }; 
  in
  {
    packages = forAllSystems (system:{
      holesail = pkgs.${system}.buildNpmPackage rec {
        pname = "holesail";
        version = "1.8.0";
        src = pkgs.${system}.fetchFromGitHub {
          owner = "holesail";
          repo = pname;
          rev = "refs/tags/${version}";
          hash = "sha256-wjXixbzxc2vSERZgGSTken9ZqkzlkNCDBpzWXKP0VYs=";
        };

        npmDepsHash = "sha256-bF2yK2JGQcqV/dobe8Sw8F3M2UAk8OH8s9odYFJ2otg=";
        npmPackFlags = [ "--ignore-scripts" ];
        buildPhase = "echo 'No build phase required'";
        meta = {
          description = "Holesail!";
          homepage = "holesail.io";
          license = nixpkgs.lib.licenses.gpl3Only;
        };
      };
    });

  };

}