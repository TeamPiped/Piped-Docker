#!/bin/sh
echo "Enter a hostname for the Frontend (eg: piped.kavin.rocks):" && read -r frontend
echo "Enter a hostname for the Backend (eg: pipedapi.kavin.rocks):" && read -r backend
echo "Enter a hostname for the Proxy (eg: pipedproxy.kavin.rocks):" && read -r proxy
echo "Enter the reverse proxy you would like to use (either caddy or nginx):" && read -r reverseproxy
echo "Is your hostname reachable via HTTP or HTTPS? (eg: https)" && read -r http_mode

rm -rf config/
rm -f docker-compose.yml

cp -r template/ config/

conffiles=$(find config/ -type f ! -name '*.yml')
sed -i "s/FRONTEND_HOSTNAME/$frontend/g" $conffiles
sed -i "s/BACKEND_HOSTNAME/$backend/g" $conffiles
sed -i "s/PROXY_HOSTNAME/$proxy/g" $conffiles

sed -i "s/BACKEND_HOSTNAME_PLACEHOLDER/$backend/g" config/*.yml
sed -i "s/HTTP_MODE_PLACEHOLDER/$http_mode/g" config/*.yml

mv config/docker-compose.$reverseproxy.yml docker-compose.yml
