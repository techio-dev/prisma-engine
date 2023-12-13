FROM alpine:3.18 as builder
WORKDIR /app/prisma
ARG PRISMA_VERSION
ENV QUERY_ENGINE_URL="https://binaries.prisma.sh/all_commits/${PRISMA_VERSION}/linux-musl/query-engine.gz"

RUN wget -O query-engine.gz $QUERY_ENGINE_URL
RUN gunzip query-engine.gz
RUN chmod +x query-engine
# install prisma
FROM alpine:3.18
RUN apk add openssl1.1-compat libgcc
COPY --from=builder /app/prisma/query-engine /query-engine
EXPOSE 8888
CMD [ "/query-engine", "--host=0.0.0.0",  "--port=8888", "-g", "-m", "-o" ]
