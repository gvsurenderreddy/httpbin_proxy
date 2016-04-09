FROM perl:latest
RUN cpanm Mojolicious
COPY . /usr/local/app
EXPOSE 3000
WORKDIR /usr/local/app
ENTRYPOINT morbo script/mojo_test2
