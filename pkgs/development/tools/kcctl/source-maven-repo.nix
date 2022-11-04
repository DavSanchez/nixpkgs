{ lib, stdenv, fetchFromGitHub, jre, maven, version }:
stdenv.mkDerivation rec {
  name = "kcctl-maven-repository";
  buildInputs = [ jre maven ];

  src = fetchFromGitHub {
    owner = "kcctl";
    repo = "kcctl";
    rev = version;
    sha256 = "sha256-TsFj0Q9JR0v+ct1KFvAe21jOzF3Vn5z4uorD1wrc9vI=";
  };

  buildPhase = "./mvnw package";

  installPhase = "cp -r target/quarkus-app $out";

  dontFixup = true;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-E3FL7LxCDyIaq/QVVkBHuFrB6w/bHde7+j0f+P8tzag=";
}

