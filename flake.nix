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
        version = "1.8.3";
        src = pkgs.${system}.fetchFromGitHub {
          owner = "holesail";
          repo = pname;
          rev = "refs/tags/${version}";
          hash = "sha256-R487u6QX0eyNyJ9kRe5kXJ0HUgYIB9yGdXJGiuZ1keA=";
        };

        npmDepsHash = "sha256-LYr5hNEC5e6ddQVYrgmOX2N/hJcrseJGOq58i4UHOLU=";
        npmPackFlags = [ "--ignore-scripts" ];
        buildPhase = "echo 'No build phase required'";
        meta = {
          description = "Peer to Peer tunnels for Instant Access
                        Create P2P tunnels instantly that bypass any network, firewall, NAT restrictions
                        and expose your local network to the internet securely,
                        no Dynamic DNS required.";
          homepage = "holesail.io";
          license = nixpkgs.lib.licenses.gpl3Only;
        };
      };
    });

  };

}