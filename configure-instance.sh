echo "Enter a hostname for the Frontend (eg: piped.kavin.rocks):"
read frontend

echo "Enter a hostname for the Backend (eg: pipedapi.kavin.rocks):"
read backend

echo "Enter a hostname for the Proxy (eg: pipedproxy.kavin.rocks):"
read proxy

rm -rf config/

cp -r template/ config/

sed -i "s/FRONTEND_HOSTNAME/$frontend/g" config/*
sed -i "s/BACKEND_HOSTNAME/$backend/g" config/*
sed -i "s/PROXY_HOSTNAME/$proxy/g" config/*
