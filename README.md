# Piped-Docker

## General notes

### Requirements

To Self-host Piped you're going to need the following resources:

- Three DNS entries, one for each of the three modules: Frontend, Backend (API) and Youtube Proxy.
- An SSL certificate for HTTPS. An exemple is supplied, but you should create your own or get one from Let's Encrypt
- A container manager - Docker or Podman - with the corresponding \*-composer.

For an instance serving only a private network, you most likely going to use a self-signed certificate, since Let's Encrypt needs access to the server on port 80 to validate that you actually owns it.

### Note to selfhosters running Proxmox

If you're going to selfhost Piped on an LXC container created by Proxmox, note that They're perfectly capable of running both Docker an Podman containers. This is called nesting, the act of running containers inside containers.

There are one caveat, tho. It has to do with how services are started on LXC. Those containers normaly don't have a non-root user, so you login directly as root with SSH. Some people might be tempted to create a normal user and then use `sudo` to become root. This will cause you a lot of pain, because by doing that, you won't have a d-bus session running, d-bus is started as user unit by Systemd, but this doesn't run when you `sudo` to the user, only when you login directly as the user. I haven't tested this with Docker, but Podman breaks a little in this scenario, so if you're running Podman inside an LXC container, SSH as root from the beginning.

WAIT!!! Can't I run Podman without being root ? Well, the Nginx reverse proxy the Piped uses to distribute requests to frontend, backend or ytproxy listens on ports 80 and 443, so you need to be root in order to open those. If you want to run rootless, you're gonna have to tinker a little, but you'll be on uncharted waters, sorry.

## Configuration

### Creating Self-signed certificate

To create your own certificate, follow the instructions on this [DigitalOcean tutorial](https://www.digitalocean.com/community/tutorials/openssl-essentials-working-with-ssl-certificates-private-keys-and-csrs#generating-ssl-certificates), placing the files on the `config/` directory, replacing `piped.key` and `piped.crt` with the ones you created. To save you some time, you can use this command:

    cd config/
    openssl req -newkey rsa:2048 -nodes -keyout piped.key -x509 -days 365 -out piped.crt

Answer all the question with appropriate values, the **only important field** that you should pay attention to is "**Common Name (e.g. server FQDN or YOUR name) []**", this should be "*.yourdomain.tld", meaning this certificate will server for all three hosts needed for Piped.

### Configuring Piped

All configurations should preferably be done using environment variables. All of them are listed on the [[configuration.env]] file.

The most important to set up are the FQDN (Fully Qualified Domain Names) of the three services. These names should be configured on the variables BACKEND_HOSTNAME, FRONTEND_HOSTNAME and PROXY_HOSTNAME **without** "https:\/\/", slashes or anything other than the FQDN. The URLs **with** "https:\/\/" should be configured in the variables FRONTEND_URL, API_URL and PROXY_PART.

There are other settings that you can change in the file too, such as support for Captcha, registration, etc., just look for them on the config file.

### Configuring Postgres

Piped uses PostgreSQL. It is the only DB supported and it's included in the composer file. If you want to use an external Postgre instead, put the relevant information on the appropriate variables and comment the `postgres` service on the composer file. If you decide to use the included DB, these variables will be used both to create the database and to configure the Hibernate library used by the backend.

## Running

After you finish creating the certificate and setting up the environment variables, run the project with one of the following commands:

- Docker

    docker-compose up -d

- Podman

    podman-compose up -d

Once all the containers finish starting, test if it's working by pointing your browser to https://frontend.yourdomain.tld and confirm that Piped loads the "Trending" page.

## Debuging

In case of problems, you can check the logs with \*-compose logs <container>. For exemple:

    docker-compose logs nginx   # For docker users
    
    or
    
    podman-compose logs piped-backend   # for Podman users

If you need really verbose logs from Nginx, it is possible to enable debug mode, but it requires forcing the container to run `nginx-debug` instead of plain `nging` and adding a `error_log ... debug;` statement to [[config/piped.conf.template]].
