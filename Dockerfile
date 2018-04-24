# base image elixer to start with
FROM elixir:1.4.4

# install hex package manager
RUN mix local.hex --force

# install phoenix
RUN mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# install node
RUN curl -sL https://deb.nodesource.com/setup_6.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install nodejs

# create app folder
#RUN mkdir /app
COPY ./writers_unblocked /app
WORKDIR /app

# setting the port and the environment (prod = PRODUCTION!)
ENV MIX_ENV=prod
ENV PORT=4000

# install dependencies (production only)
RUN mix local.rebar --force
RUN mix deps.get --only prod
RUN mix compile

# npm files are in the assets directory
WORKDIR /app/assets
# install node dependencies
RUN npm install
# build only the things for production
RUN node node_modules/brunch/bin/brunch build --production

WORKDIR /app

# create the digests
RUN mix phx.digest

CMD mix ecto.create && mix phx.server
