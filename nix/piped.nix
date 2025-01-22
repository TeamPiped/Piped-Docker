{ config, lib, pkgs, ... }:

let
    pipedPackage = pkgs.callPackage ./piped-package.nix { pipedConfig = config.piped; };
in lib.mkIf config.piped.enable {
    virtualisation.docker.enable = true;
    systemd.services.piped = {
        enable = true;
        serviceConfig = {
            WorkingDirectory = pipedPackage;
            preStart = "${pkgs.docker-compose}/bin/docker-compose pull";
            ExecStart = "${pkgs.docker-compose}/bin/docker-compose up";
            ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
        };
        environment.COMPOSE_PROJECT_NAME = "piped-flake";
        after = [ "docker.service" "docker.socket" ];
        wantedBy = [ "multi-user.target" ];
    };
}
