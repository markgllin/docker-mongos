FROM mongo:3.4.6

ARG APP_USER=mongod
RUN groupadd -g 451 ${APP_USER} && \
  useradd -r -u 448 -g ${APP_USER} --home-dir /${HOME_DIR} ${APP_USER}
    
EXPOSE 27017
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]