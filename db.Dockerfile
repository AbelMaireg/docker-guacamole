FROM guacamole/guacamole:1.6.0 AS schema-generator

RUN /opt/guacamole/bin/initdb.sh --postgresql > /tmp/initdb.sql

# ---

FROM postgres:18 AS runtime

COPY --from=schema-generator \
    /tmp/initdb.sql /docker-entrypoint-initdb.d/initdb.sql

ENV POSTGRES_DB=${DB_NAME:-guacamole_db} \
    POSTGRES_USER=${DB_USER:-admin} \
    POSTGRES_PASSWORD=${DB_PASS:-password}

VOLUME ["/var/lib/postgresql/data"]
EXPOSE 5432

CMD ["postgres"]
