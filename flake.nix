{
    description = "A Nix flake for Holesail!!!";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    };

    outputs = { self, nixpkgs, ... } @ inputs:
    let
       system = "aarch64-linux";
       pkgs = import nixpkgs {inherit system; };
    in 
    {
        packages.holesail = pkgs.buildNpmPackage rec {
                                pname = "holesail";
                                version = "1.7.3";

                                src = pkgs.fetchFromGitHub {
                                owner = "holesail";
                                repo = pname;
                                rev = "refs/tags/${version}";
                                hash = "sha256-u7u+bljBEkbLWRrXMDZdgAe1xozx2rlqgnXSFxGqFVk=";
                                };
                                npmDepsHash = "sha256-lZEpP14sN62LOv85VsGEIWAHXQuRt6lfhbp/iGpffX4=";
                                npmPackFlags = [ "--ignore-scripts" ];
                                buildPhase = "echo 'No build phase required'";
                                meta = {
                                description = "Holesail!";
                                homepage = "holesail.io";
                                license = pkgs.lib.licenses.gpl3Only;
                                maintainers = with pkgs.lib.maintainers; [ pkgs.lib.maintainers.jjacke13 ];
                                };  
        };
    };
}