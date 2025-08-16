{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.10.1";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eANDS4Avu6or+1XXRmM+rceZzjKchhoc5nbv1grpvwE=";
  };

  npmDepsHash = "sha256-TKxm8WdsJ6fbs8WBAN7yxNQoJ43fTQghD0KYGxRRd50=";

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
