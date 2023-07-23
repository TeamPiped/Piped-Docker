# Piped-Docker

### Requirements

To Self-host Piped you're going to need the following resources:

- Three DNS entries, one for each of the three modules: Frontend, Backend (API) and Youtube Proxy.
- An SSL certificate for HTTPS. An exemple is supplied, but you should create your own or get one from Let's Encrypt
- A container manager - Docker or Podman - with the corresponding \*-composer.

For an instance serving only a private network, you most likely going to use a self-signed certificate, since Let's Encrypt needs access to the server on port 80 to validate that you actually owns it.

### Creating Self-signed certificate

https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates


