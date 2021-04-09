FROM ubuntu:18.04

ENV LANG C.UTF-8
ENV TZ America/Argentina
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN set -x; \
        apt-get update \
        && apt-get install -y --no-install-recommends \
            ca-certificates \
            curl \
            dirmngr \
            fonts-noto-cjk \
            gnupg \
            libssl1.0-dev \
            node-less \
            python3 \
            python3-pip \
            git \
            python3-dev \
            python3-phonenumbers \
            python3-pyldap \
            python3-qrcode \
            python3-renderpm \
            python3-setuptools \
            python3-slugify \
            python3-vobject \
            python3-watchdog \
            python3-xlrd \
            xz-utils \
            gcc \
            build-essential \
            libxml2-dev \
            libxslt1-dev \
            libfreetype6-dev \
            libfribidi-dev \
            libghc-zlib-dev \
            libharfbuzz-dev \
            libjpeg-dev \
            liblcms2-dev \
            libldap2-dev \
            libopenjp2-7-dev \
            libpq-dev \
            libsasl2-dev \
            libtiff5-dev \
            libwebp-dev \
        && curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb \
        && echo 'f1689a1b302ff102160f2693129f789410a1708a wkhtmltox.deb' | sha1sum -c - \
        && apt-get install -y --no-install-recommends ./wkhtmltox.deb \
        && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# install latest postgresql-client
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' >> /etc/apt/sources.list.d/postgresql.list \
        && curl -SL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
        && apt-get update \
        && apt-get install -yqq --no-install-recommends postgresql-client \
        && rm -f /etc/apt/sources.list.d/pgdg.list \
        && rm -rf /var/lib/apt/lists/*

## install extra libs
RUN pip3 install --upgrade pip \
        && pip3 install --upgrade setuptools
RUN pip3 install pysftp==0.2.8 polib==1.1.0 unicodecsv unidecode email_validator num2words xlwt lxml

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
RUN sed -i "s,^\(logfile = \).*,\1"/var/log/odoo/odoo-server.log"," /etc/odoo/odoo.conf

# Create odoo user
RUN adduser --system --quiet --shell=/bin/bash --home=/opt/odoo --gecos 'odoo' --group odoo \
        && mkdir /var/log/odoo/

RUN chown odoo /etc/odoo/odoo.conf \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

ENV ODOO_VERSION "13.0"
RUN git clone --depth=1 --branch=$ODOO_VERSION https://github.com/odoo/odoo /opt/odoo/odoo \
        && chown odoo:odoo /opt/odoo/ -R \ 
        && chown odoo:odoo /var/log/odoo/ -R

RUN pip3 install -r /opt/odoo/odoo/requirements.txt

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py

RUN ln -s /opt/odoo/odoo/odoo-bin /usr/bin/odoo
RUN chown -R odoo: /var/lib/odoo
RUN chown -R odoo: /opt/odoo

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]