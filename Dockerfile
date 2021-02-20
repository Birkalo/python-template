FROM mysql/mysql-server:8.0
EXPOSE 3306
EXPOSE 3308
ENV MYSQL_ROOT_PASSWORD password

COPY ./SQL_Scripts /docker-entrypoint-initdb.d/