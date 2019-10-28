FROM ruby:alpine
MAINTAINER Ives Schneider <sec@i-401.xyz>

# The default mirror (dl-cdn.alpinelinux.org) has issues sometimes for me
# More mirrors available here: mirrors.alpinelinux.org
RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.9/main" > /etc/apk/repositories && \
	echo "http://dl-cdn.alpinelinux.org/alpine/v3.9/community" >> /etc/apk/repositories
RUN apk update && \
	apk add --no-cache --virtual build-deps build-base icu-dev cmake && \
	apk add --no-cache icu-libs git

RUN gem install gollum \
	github-markdown \
	asciidoctor

RUN apk del build-deps \
	&& rm /etc/apk/repositories

WORKDIR /wiki
# create a volume and
ENTRYPOINT ["/bin/sh", "-c", "git init && gollum /wiki"]
CMD ["--allow-uploads","page","--live-preview"]
