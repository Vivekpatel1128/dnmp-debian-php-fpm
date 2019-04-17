FROM debian:stretch

LABEL maintainer "j.zelger@techdivision.com"

# copy all filesystem relevant files
COPY fs /tmp/

# start install routine
RUN \

    # install base tools
    apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
            vim less tar wget curl apt-transport-https ca-certificates apt-utils net-tools htop \
            python-setuptools python-wheel python-pip pv software-properties-common dirmngr gnupg && \

    # copy repository files
    cp -r /tmp/etc/apt /etc && \

    # add repository keys
    apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
    apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys 5072E1F5 && \
    curl https://packages.sury.org/php/apt.gpg | apt-key add - && \

    # update repositories
    apt-get update && \

    # define deb selection configurations

    # prepare compatibilities for docker

    # install supervisor
    pip install supervisor && \
    pip install supervisor-stdout && \

    # add our user and group first to make sure their IDs get assigned consistently,
    # regardless of whatever dependencies get added

    # install packages
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        # php 7.0
        php7.0 php7.0-cli php7.0-common php7.0-fpm php7.0-curl php7.0-gd php7.0-mcrypt php7.0-mysql php7.0-soap \
        php7.0-json php7.0-zip php7.0-intl php7.0-bcmath php7.0-xsl php7.0-xml php7.0-mbstring php7.0-xdebug \
        php7.0-mongodb php7.0-ldap php7.0-imagick php7.0-readline php7.0-sqlite3 \
        # php 7.1
        php7.1 php7.1-cli php7.1-common php7.1-fpm php7.1-curl php7.1-gd php7.1-mcrypt php7.1-mysql php7.1-soap \
        php7.1-json php7.1-zip php7.1-intl php7.1-bcmath php7.1-xsl php7.1-xml php7.1-mbstring php7.1-xdebug \
        php7.1-mongodb php7.1-ldap php7.1-imagick php7.1-readline php7.1-sqlite3 \
        # php 7.2
        php7.2 php7.2-cli php7.2-common php7.2-fpm php7.2-curl php7.2-gd php7.2-mysql php7.2-soap \
        php7.2-json php7.2-zip php7.2-intl php7.2-bcmath php7.2-xsl php7.2-xml php7.2-mbstring php7.2-xdebug \
        php7.2-mongodb php7.2-ldap php7.2-imagick php7.2-readline php7.2-sqlite3 && \

    # define default php cli version
    update-alternatives --set php /usr/bin/php7.0 && \

    # install elasticsearch plugins

    # copy provided fs files
    cp -r /tmp/usr / && \
    cp -r /tmp/etc / && \

    # setup filesystem
    mkdir -p /var/run/php && \
    chmod a+x /usr/local/bin/docker-entrypoint.sh && \

    # cleanup
    apt-get clean && \
    rm -rf /tmp/* /var/lib/apt/lists/*

# define entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# define cmd
CMD ["supervisord", "--nodaemon", "-c", "/etc/supervisord.conf"]
