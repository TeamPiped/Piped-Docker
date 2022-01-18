# Check if Docker-Compose is not installed
if [ -z "$(which docker-compose)" ]; then
    echo "Docker-Compose is not installed. Please install it first from https://docs.docker.com/compose/install/#install-compose."
    exit 1
fi

# Docker-Compose version check, to prevent "Unsupported configuration option"
COMPOSE_VERSION=$(docker-compose version --short)
REQUIRED_COMPOSE_VERSION="1.28.0"
if [[ $(printf '%s\n' "$REQUIRED_COMPOSE_VERSION" "$COMPOSE_VERSION" | sort -V | head -n1) != $REQUIRED_COMPOSE_VERSION ]]; then
    echo "Your docker-compose version of $COMPOSE_VERSION is too old. Please upgrade to $REQUIRED_COMPOSE_VERSION or higher."
    echo "See https://docs.docker.com/compose/install/#install-compose for installation instructions."
    exit 1
fi

echo "Enter an url for the Frontend (eg: https://piped.kavin.rocks):" && read -r frontend_url

echo "Enter an url for the Backend (eg: https://pipedapi.kavin.rocks):"" && read -r backend_url

echo "Enter an hostname for the Proxy (eg: https://pipedproxy.kavin.rocks):"" && read -r proxy_url

echo "Enter the reverse proxy you would like to use (either caddy or nginx):"" && read -r reverseproxy

rm -rf config/
rm -f docker-compose.yml

cp -r template/ config/

frontend_hostname=$(echo "$frontend_url"| awk -F[/:] '{print $4}')
backend_hostname=$(echo "$backend_url"| awk -F[/:] '{print $4}')
proxy_hostname=$(echo "$proxy_url"| awk -F[/:] '{print $4}')

sed -i "s@FRONT_URL@$frontend_url@g" config/*
sed -i "s@BACKEND_URL@$backend_url@g" config/*
sed -i "s@PROXY_URL@$proxy_url@g" config/*

sed -i "s@FRONTEND_HOSTNAME@$frontend_hostname@g" config/*
sed -i "s@BACKEND_HOSTNAME@$backend_hostname@g" config/*
sed -i "s@PROXY_HOSTNAME@$proxy_hostname@g" config/*

# The openj9 image does not support aarch64
if [[ "$(uname -m)" == "aarch64" ]]; then
    sed -i "s/piped:latest/piped:hotspot/g" config/*
fi

mv config/docker-compose.$reverseproxy.yml docker-compose.yml
