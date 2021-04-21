#!/bin/bash

set -e

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${HOST:=${DB_PORT_5432_TCP_ADDR:='db'}}
: ${PORT:=${DB_PORT_5432_TCP_PORT:=5432}}
: ${USER:=${DB_ENV_POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${PASSWORD:=${DB_ENV_POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='odoo'}}}

DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then       
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" |cut -d " " -f3|sed 's/["\n\r]//g')
    fi;
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}
check_config "db_host" "$HOST"
check_config "db_port" "$PORT"
check_config "db_user" "$USER"
check_config "db_password" "$PASSWORD"

MODULES_PATH="/opt/odoo/addons,/mnt/base-addons/ingadhoc/odoo-argentina,/mnt/base-addons/ingadhoc/odoo-argentina-ce,/mnt/base-addons/ingadhoc/argentina-sale,/mnt/base-addons/ingadhoc/miscellaneous,/mnt/base-addons/ingadhoc/account-payment,/mnt/base-addons/ingadhoc/account-financial-tools,/mnt/base-addons/ingadhoc/aeroo_reports,/mnt/base-addons/ingadhoc/account-invoicing,/mnt/base-addons/ingadhoc/partner,/mnt/base-addons/ingadhoc/account-analytic,/mnt/base-addons/ingadhoc/hr,/mnt/base-addons/ingadhoc/product,/mnt/base-addons/ingadhoc/multi-company,/mnt/base-addons/ingadhoc/purchase,/mnt/base-addons/ingadhoc/stock,/mnt/base-addons/ingadhoc/website,/mnt/base-addons/ingadhoc/sale,/mnt/base-addons/ingadhoc/project,/mnt/base-addons/ingadhoc/argentina-reporting,/mnt/base-addons/ingadhoc/reporting-engine,/mnt/base-addons/ingadhoc/multi-store,/mnt/base-addons/oca/web,/mnt/base-addons/oca/account-financial-tools,/mnt/base-addons/oca/account-financial-reporting,/mnt/base-addons/oca/server-ux,/mnt/base-addons/oca/reporting-engine"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@" "--addons-path=$MODULES_PATH"
        else
            wait-for-psql.py ${DB_ARGS[@]} --timeout=30
            exec odoo "$@" "${DB_ARGS[@]}" "--addons-path=$MODULES_PATH"
        fi
        ;;
    -*)
        wait-for-psql.py ${DB_ARGS[@]} --timeout=30
        exec odoo "$@" "${DB_ARGS[@]}" "--addons-path=$MODULES_PATH"
        ;;
    *)
        exec "$@"
esac

exit 1
