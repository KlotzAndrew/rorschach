FROM elixir:1.4.1

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir /code
WORKDIR /code

COPY mix.exs /code/mix.exs
COPY mix.lock /code/mix.lock
RUN mix deps.get

COPY . ./code

