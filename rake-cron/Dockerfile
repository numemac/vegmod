FROM auguryan/vegmod-rails:latest

USER root

WORKDIR /rails

# Set debian mirror
COPY sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y cron vim

# Setup the crontab
COPY ./rake.crontab /etc/cron.d/rake.crontab
RUN chmod 0644 /etc/cron.d/rake.crontab
RUN crontab /etc/cron.d/rake.crontab

# https://stackoverflow.com/a/62613296
RUN ln -s /usr/local/bin/ruby /usr/bin/ruby
RUN ln -s /usr/local/bin/bundle /usr/bin/bundle

# https://askubuntu.com/a/940321
ENV PATH="/usr/local/bin:${PATH}"

# Run cron
CMD ["sh", "-c", "env >> /etc/environment && cron -f"]