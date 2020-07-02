FROM mongo:3.4.6

EXPOSE 27017
COPY entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]