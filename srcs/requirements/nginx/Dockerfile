FROM debian:bullseye

ARG DOM_NAME
ARG NGINX_PASS_LINE
ARG TOOL_DIR
ARG CA_NAME
ARG SERVER_NAME

RUN apt update \
    && apt install -y nginx openssl

COPY ${TOOL_DIR}/site-conf /etc/nginx/sites-available/ 

RUN mkdir -p /var/www/${DOM_NAME} \
    && mkdir -p /var/www/${DOM_NAME}/admin
COPY ${TOOL_DIR}/index.html.template /var/www/${DOM_NAME}
COPY ${TOOL_DIR}/admin.html /var/www/${DOM_NAME}/admin
COPY ${TOOL_DIR}/cert/${SERVER_NAME}.key /etc/ssl/private/${SERVER_NAME}.key
COPY ${TOOL_DIR}/cert/${SERVER_NAME}.pem /etc/ssl/certs/${SERVER_NAME}.pem
COPY ${TOOL_DIR}/cert/${CA_NAME}.pem /etc/ssl/certs/${CA_NAME}.pem

# sed inside site-conf, index.html.template

RUN mv /etc/nginx/sites-available/site-conf /etc/nginx/sites-available/${DOM_NAME} \
    && ln -s /etc/nginx/sites-available/${DOM_NAME} /etc/nginx/sites-enabled/${DOM_NAME} \
    && rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default \
    && sed "s/{{ DOM_NAME }}/${DOM_NAME}/g" /var/www/${DOM_NAME}/index.html.template > /var/www/${DOM_NAME}/index.html \
    && sed -i -e "s/TLSv1 //" -e "s/TLSv1.1 //" /etc/nginx/nginx.conf \
    && rm /var/www/${DOM_NAME}/index.html.template \
    && sed -i "s/{{ DOM_NAME }}/${DOM_NAME}/g" /etc/nginx/sites-available/${DOM_NAME} \
    && echo "${NGINX_PASS_LINE}" > /etc/nginx/passwords

RUN nginx -t

EXPOSE 80
EXPOSE 443

ENTRYPOINT [ "nginx" ]

CMD [ "-g", "daemon off;" ]