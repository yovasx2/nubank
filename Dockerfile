FROM ruby:2.7.3

RUN apt-get update -qq
WORKDIR /app
COPY . .
RUN bundle install -j4

CMD ["echo", "no default command"]
