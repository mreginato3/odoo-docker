# odoo-docker

## Pasos para levantar el entorno de docker:

1. `git clone https://github.com/mreginato3/odoo-docker.git odoo13 && cd odoo13`
2. Chequeamos que en el docker-compose se esté utilizando la imagen de odoo que queremos.
    - Para esto, abrimos el docker-compose y revisamos 
         ```
         odoo:
            image: regmarcos/odoo:13.0-extended 
        ```        
3.`docker-compose up` (Si queremos levantar el docker-compose y que siga corriendo en segundo plano hacemos `docker-compose up -d`)

* Para ingresar al container:
    * `docker exec -it odoo13_odoo_1 bash`
* Si queremos ingresar como root:
    * `docker exec -it -u root odoo13_odoo_1 bash`
