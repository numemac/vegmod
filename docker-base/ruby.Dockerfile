FROM registry.docker.com/library/ruby:3.3.4-bookworm

# Remove the default sources.list
RUN rm -rf /etc/apt/sources.list.d/*

# Set debian mirror
COPY sources.list /etc/apt/sources.list

RUN apt-get update