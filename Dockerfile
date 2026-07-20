FROM golang:1.22 AS base

WORKDIR /app

COPY go.mod . 

RUN go mod download

COPY . .

RUN go build -o app .

# Final stage - Distroless image
FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=base /app/app /app/          
COPY --from=base /app/static ./static

EXPOSE 8080

CMD ["/app/app"]                         
