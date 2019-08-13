FROM ruby:2.6

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  nodejs \
  vim \
  yarn

COPY Gemfile* /usr/src/fitrep/
WORKDIR /usr/src/fitrep
RUN bundle install

COPY . /usr/src/fitrep

ENTRYPOINT ["./docker-entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]
