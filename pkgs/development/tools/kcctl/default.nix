{ lib, stdenv, callPackage, jre, makeWrapper }:
stdenv.mkDerivation rec {
  name = "kcctl";
  version = "v1.0.0.Alpha5";

  src = callPackage ./source-maven-repo.nix { inherit version; };
  buildInputs = [ jre ];
  nativeBuildInputs = [ makeWrapper ];

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
