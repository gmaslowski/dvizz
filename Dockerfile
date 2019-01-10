# build stage: fetch bower dependencies
FROM resin/raspberry-pi-node AS bower

WORKDIR /dvizz

ADD . /dvizz
RUN npm install -g bower && bower --allow-root install



# build stage: dvizz golang binary
FROM resin/raspberry-pi-golang AS golang

WORKDIR /dvizz

ADD . /dvizz
RUN go get -v -d && CGO_ENABLED=0 go build -a -o dvizz



# final image
FROM resin/rpi-raspbian:jessie

EXPOSE 6969

WORKDIR /dvizz

ADD static/ static/
COPY --from=golang /dvizz/dvizz .
COPY --from=bower /dvizz/static/js static/js

ENTRYPOINT ["./dvizz"]
CMD []
