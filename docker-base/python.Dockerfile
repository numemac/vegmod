FROM python:3.12.4-bookworm

# Remove the default sources.list
RUN rm -rf /etc/apt/sources.list.d/*

# Set debian mirror
COPY sources.list /etc/apt/sources.list

RUN apt-get update

# Pre-install basic utilities
RUN apt-get update && apt-get install -y cron curl vim