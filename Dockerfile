FROM debian:buster
RUN adduser --disabled-password --gecos "" notroot
RUN apt-get -qq update && \
    apt-get -qq install build-essential \
			file \
			wget \
			cpio \
			python \
			python3 \
			unzip \
			rsync \
			bc \
			git \
			libyaml-dev
USER notroot
