{ 
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "holesail";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-eANDS4Avu6or+1XXRmM+rceZzjKchhoc5nbv1grpvwE=";
  };

  npmDepsHash = "sha256-TKxm8WdsJ6fbs8WBAN7yxNQoJ43fTQghD0KYGxRRd50=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = lib.licenses.gpl3Only;
  };
}
