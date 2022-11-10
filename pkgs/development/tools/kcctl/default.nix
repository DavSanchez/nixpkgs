{ lib, stdenv, buildMaven, fetchFromGitHub, jre, maven, makeWrapper }:
stdenv.mkDerivation rec {
  name = "kcctl";
  version = "v1.0.0.Alpha5";

  dependencies = (buildMaven ./project-info.json).repo; # callPackage ./source-maven-repo.nix { inherit version; };
  
  src = fetchFromGitHub {
    owner = "kcctl";
    repo = "kcctl";
    rev = version;
    sha256 = "sha256-TsFj0Q9JR0v+ct1KFvAe21jOzF3Vn5z4uorD1wrc9vI=";
  };
  
  buildInputs = [ jre maven ];
  nativeBuildInputs = [ makeWrapper ];
  
  buildPhase = ''
    mvn -B --file pom.xml --offline package "-Dmaven.repo.local=${dependencies}"
  '';

  installPhase = ''
    runHook preInstall

    find . -type f -exec install -Dm644 "{}" "$out/share/java/{}" \;

    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/${name} \
        --add-flags "-jar $out/share/java/quarkus-run.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A modern and intuitive command line client for Kafka Connect";
    longDescription = ''
      This project is a command-line client for Kafka Connect.
      Relying on the idioms and semantics of kubectl, it allows you to register and examine connectors, delete them, restart them, etc.
    '';
    homepage = "https://github.com/kcctl/kcctl";
    changelog = "https://github.com/kcctl/kcctl/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.davsanchez ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
