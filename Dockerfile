FROM develar/java:8u45
WORKDIR /data
RUN apk add --update bash
ENTRYPOINT ["bin/jruby"]