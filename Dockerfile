ARG APP_USER=mongod

FROM mongo:3.4.6
RUN groupadd -g 451 ${APP_USER} && \
    useradd -r -u 448 -g ${APP_USER}
    
EXPOSE 27017
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]