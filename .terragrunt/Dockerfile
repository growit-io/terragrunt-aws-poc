FROM golang:1.16

WORKDIR /go/src/tg
COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

CMD ["tg"]
