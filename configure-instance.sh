#!/usr/bin/env bash
echo "Enter a hostname for the Frontend (eg: piped.kavin.rocks):" && read -r frontend
echo "Enter a hostname for the Backend (eg: pipedapi.kavin.rocks):" && read -r backend
echo "Enter a hostname for the Proxy (eg: pipedproxy.kavin.rocks):" && read -r proxy
echo "Enter the reverse proxy you would like to use (either caddy or nginx):" && read -r reverseproxy

rm -rf config/
rm -f docker-compose.yml

cp -r template/ config/

sed -i "s/FRONTEND_HOSTNAME/$frontend/g" config/*
sed -i "s/BACKEND_HOSTNAME/$backend/g" config/*
sed -i "s/PROXY_HOSTNAME/$proxy/g" config/*

# The openj9 image does not support aarch64
if [[ "$(uname -m)" == "aarch64" ]]; then
    sed -i "s/piped:latest/piped:hotspot/g" config/*
fi

mv config/docker-compose.$reverseproxy.yml docker-compose.yml
