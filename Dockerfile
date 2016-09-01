FROM ruby:2.3.1-slim

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
            build-essential \
            libpq-dev \
            libmysqlclient-dev \
            nodejs \
            nodejs-legacy \
            npm \
            git \
        && rm -rf /var/lib/apt/lists/*

RUN npm install -g bower
RUN mkdir /app

ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
ADD vendor/assets/bower.json /tmp/vendor/assets/bower.json
ADD vendor/assets/.bowerrc /tmp/vendor/assets/.bowerrc

WORKDIR /app
RUN cd /tmp \
        && bundle install -j5 --deployment --without test \
        && cd /tmp/vendor/assets \
        && bower install -p --allow-root \
        && mv /tmp/vendor /app

ADD . /app
RUN bundle exec rake assets:precompile RAILS_ENV=production

EXPOSE 3000

CMD ["./bin/docker_start.sh"]
