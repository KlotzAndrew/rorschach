FROM elixir:1.4.1

ENV APP /code

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir -p $APP
WORKDIR $APP

COPY mix.exs $APP
COPY mix.lock $APP
RUN mix deps.get

COPY . $APP

RUN mix compile
