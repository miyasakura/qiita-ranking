FROM miyasakura/nginx-rails-base:0.1

RUN curl -L -O https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar xvf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN mv phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/sbin
RUN bundle config --global frozen 1
RUN bundle config build.nokogiri --use-system-libraries

ENV APP_HOME /webapp
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/
RUN bundle install --without test development
RUN cat Gemfile.lock

ADD . $APP_HOME
RUN bundle exec rake assets:precompile
RUN mkdir -p $APP_HOME/tmp/pids
RUN mkdir -p $APP_HOME/tmp/sockets

COPY docker/nginx.conf /etc/nginx/nginx.conf

COPY docker/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80
CMD ["/usr/bin/supervisord"]

