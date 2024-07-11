{ lib, ... }:

{
  options = with lib; {
    piped = {
        enable = mkOption {
            description = "Enable the piped service";
            type = types.bool;
            default = false;
        };

        # Config for configure-instance.sh
        frontend = mkOption {
            description = "Hostname for the Frontend (eg: piped.kavin.rocks)";
            type = types.str;
        };
        backend = mkOption {
            description = "Hostname for the Backend (eg: pipedapi.kavin.rocks)";
            type = types.str;
        };
        proxy = mkOption {
            description = "Hostname for the Proxy (eg: pipedproxy.kavin.rocks)";
            type = types.str;
        };
        reverseproxy = mkOption {
            description = "Reverse proxy you would like to use (either caddy or nginx)";
            type = types.str;
        };

        # Additional Config
        dataDir = mkOption {
            description = "The path for data storage";
            type = types.str;
            default = "/var/lib/piped";
        };
        httpPort = mkOption {
            description = "The port to listen for HTTP conenctions";
            type = types.int;
            default = 80;
        };
        httpsPort = mkOption {
            description = "The port to listen for HTTPS conenctions";
            type = types.int;
            default = 443;
        };
    };
  };
}
