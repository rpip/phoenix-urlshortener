# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
apt-get install -y postgresql-client

EXPOSE 4000
ENV PORT=4000 MIX_ENV=dev

# Create app directory and copy the Elixir projects into it
RUN mkdir /app
COPY . /app
WORKDIR /app

# Install hex package manager
RUN mix local.rebar --force && \
    mix local.hex --force

# Compile the project
RUN mix do deps.get, deps.compile

# USER default
RUN ["chmod", "+x", "/app/entrypoint.sh"]

# CMD ["/app/entrypoint.sh"]
ENTRYPOINT ["bash", "/app/entrypoint.sh"]
