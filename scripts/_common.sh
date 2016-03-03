#!/bin/bash

function clean() {
    rm -rf build/env build/out docker-compose.override.yml
    docker-compose kill
    docker-compose rm -f
}

function checkComposer() {
    hash composer
    if [ $? -eq 0 ]; then
        COMPOSER=composer
    else
        if [ ! -f build/composer.phar ]; then
            curl -sS https://getcomposer.org/installer | php -- --install-dir=build >&2
        fi
        COMPOSER=build/composer.phar
    fi
}

function checkBinary() {
    hash $1
    if [ $? -ne 0 ]; then
        echo "$1 is not available on the PATH" >&2
        exit 1
    fi
}

function buildDir() {
    mkdir -p build/env build/out
}

function buildGuzzle() {
    cd tests/guzzle
    $COMPOSER install
    cd -
}

function buildEnvironments() {
    for hostname_type in good-hostname bad-hostname; do
        if [[ "${hostname_type}" == 'good-hostname' ]]; then
            hostname="example.com"
        else
            hostname="some.name.that.does.not.resolve.example"
        fi

        for dns_type in good-dns bad-dns; do
            if [[ "${dns_type}" == 'good-dns' ]]; then
                dns_use="GOOD_DNS_IP"
            else
                dns_use="BAD_DNS_IP"
            fi

            for env in `ls env/test`; do
                build="${hostname_type}_${dns_type}_${env}"
                dest="build/env/${build}"

                echo "Creating environment at ${dest}" >&2
                mkdir -p ${dest}
                cp -r tests ${dest}
                cp -r "env/test/${env}/"* ${dest}

                echo "Adding to docker-compose.override.yml" >&2

                definition=$(cat <<TEMPLATE
# -- Generated entry: ${build}
${build}:
  build: ${dest}
  environment:
    TEST_HOSTNAME: ${hostname}
  dns:
    - "\${${dns_use}}"
TEMPLATE
)
                echo "${definition}" >> docker-compose.override.yml
            done
        done
    done
}

function buildDnsInstances() {
    docker-compose up -d bad-dns
    docker-compose up -d good-dns

    bad_id=`docker-compose ps -q bad-dns`
    export BAD_DNS_IP=`docker inspect -f '{{.NetworkSettings.IPAddress}}' ${bad_id}`

    good_id=`docker-compose ps -q good-dns`
    export GOOD_DNS_IP=`docker inspect -f '{{.NetworkSettings.IPAddress}}' ${good_id}`

    if [[ -z $GOOD_DNS_IP || -z $BAD_DNS_IP ]]; then
        echo "Good and bad DNS server failed to start?" >&2
        exit 1
    fi

    echo "Bad DNS server is ${BAD_DNS_IP} (\`dig @${BAD_DNS_IP} example.com\` will fail)" >&2
    echo "Good DNS server is ${GOOD_DNS_IP} (\`dig @${GOOD_DNS_IP} example.com\` will succeed)" >&2
}

function buildOtherServices() {
    docker-compose build
}
