FROM amazon/aws-cli:latest

RUN dnf install -y mariadb105 gzip \
    && dnf clean all \
    && rm -rf /var/cache/dnf

COPY backup.sh /usr/local/bin/backup.sh

RUN chmod +x /usr/local/bin/backup.sh

ENTRYPOINT ["/usr/local/bin/backup.sh"]