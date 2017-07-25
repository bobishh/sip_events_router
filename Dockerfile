FROM ruby:2.3-alpine

ENV APP_HOME /app
RUN mkdir $APP_HOME
RUN apk update; apk add openssl make g++
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN bundle config build.eventmachine --with-cppflags=-I/usr/local/opt/openssl/include

RUN bundle install

ADD * $APP_HOME/
ADD lib $APP_HOME/lib
ADD views $APP_HOME/views

CMD /usr/local/bin/bundle exec ruby $APP_HOME/app.rb
