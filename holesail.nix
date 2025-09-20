{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.10.1";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-7YTBwjU0xzoDqlRqfdQZrJRvSXTtT8rpA1zRdLSdFoU=";
  };

  npmDepsHash = "sha256-aos1WOsVsgZG6h0g242/mz5yiN/7V+G8to8IyaKldFI=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  
  meta = with pkgs.lib; {
    description = "Holesail is a truly peer-to-peer network tunneling and reverse proxy software that supports both TCP and UDP protocols. 
        Holesail lets you share any locally running application on a specific port with third parties securely and with a single command.
        No static IP or port forwarding required.";
    homepage = "https://holesail.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      jjacke13
    ];
  };
}
