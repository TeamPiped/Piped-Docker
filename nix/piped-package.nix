{ stdenvNoCC, bash, pipedConfig }:

stdenvNoCC.mkDerivation rec {
  name = "piped";

  src = ../template;
  installer = ../configure-instance.sh;

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p "$out/template"
    cp -r . "$out/template"
    cd "$out"
    ${bash}/bin/bash ${installer} <<<$(
        echo ${pipedConfig.frontend}
        echo ${pipedConfig.backend}
        echo ${pipedConfig.proxy}
        echo ${pipedConfig.reverseproxy}
    )
    rm -rf $out/template

    sed "s|80:|${builtins.toString pipedConfig.httpPort}:|g" -i docker-compose.yml
    sed "s|443:|${builtins.toString pipedConfig.httpsPort}:|g" -i docker-compose.yml
    sed "s|\./data|${pipedConfig.dataDir}|g" -i docker-compose.yml
  '';
}
