echo "Enter an url for the Frontend (eg: https://piped.kavin.rocks):"
read frontend_url

echo "Enter an url for the Backend (eg: https://pipedapi.kavin.rocks):"
read backend_url

echo "Enter an hostname for the Proxy (eg: https://pipedproxy.kavin.rocks):"
read proxy_url

echo "Enter the reverse proxy you would like to use (either caddy or nginx):"
read reverseproxy

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

mv config/docker-compose.$reverseproxy.yml docker-compose.yml
