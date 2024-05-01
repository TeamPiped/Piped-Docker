#!/bin/sh
echo "Enter a hostname for the Frontend (eg: piped.kavin.rocks):" && read -r frontend
echo "Enter a hostname for the Backend (eg: pipedapi.kavin.rocks):" && read -r backend
echo "Enter a hostname for the Proxy (eg: pipedproxy.kavin.rocks):" && read -r proxy
echo "Enter the reverse proxy you would like to use (either caddy or nginx):" && read -r reverseproxy
port=8080 # Define default port
if [[ $reverseproxy = "nginx" ]]; then # if the nginx reverse proxy is used, we want to get a custom port
    echo "Enter a port to use for the reverse proxy:" && read -r port
fi
integerregex='^[0-9]+$'
if ! [[ $port =~ $integerregex ]] ; then # ensure that the port is an integer. If it is not set it to the default.
    port=8080
fi

rm -rf config/
rm -f docker-compose.yml

cp -r template/ config/

sed -i "s/FRONTEND_HOSTNAME/$frontend/g" config/*
sed -i "s/BACKEND_HOSTNAME/$backend/g" config/*
sed -i "s/PROXY_HOSTNAME/$proxy/g" config/*
sed -i "s/PORT_VALUE/$port/g" config/*

mv config/docker-compose.$reverseproxy.yml docker-compose.yml
