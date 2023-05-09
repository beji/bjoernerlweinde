FROM httpd:alpine3.17

COPY ./public/ /usr/local/apache2/htdocs
