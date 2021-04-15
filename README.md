# odoo-docker

## Pasos para levantar el entorno de docker:

1. `git clone https://github.com/mreginato3/odoo-docker.git odoo13 && cd odoo13`
2. Chequeamos que en el docker-compose se esté utilizando el Dockerfile que precisamos. (Por el momento solo estan 13.0 y 13market)
    - Para esto, abrimos el docker-compose y revisamos 
         ```
         odoo:
            build:
                context: "./13market/" # 13market o 13.0 
        ```        
3.`docker-compose up -d`

Para ingresar al container:
    -`docker exec -it odoo13_odoo_1 bash`
Si queremos ingresar como root:
    -`docker exec -it -u root odoo13_odoo_1 bash`
