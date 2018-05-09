#!/bin/bash
set -e


#should the script fail midway, would be good to skip this begin part and jump to middle, dunno how to do that right now.
wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_19.0-1~ubuntu~xenial_amd64.deb
wget https://packages.erlang-solutions.com/erlang/elixir/FLAVOUR_2_download/elixir_1.4.2-1~ubuntu~xenial_amd64.deb

sudo gdebi esl-erlang_19.0-1~ubuntu~xenial_amd64.deb
sudo gdebi elixir_1.4.2-1~ubuntu~xenial_amd64.deb

mix local.hex

mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

sudo apt-get install nodejs-legacy

sudo apt-get install inotify-tools

mix phx.new writers_unblocked

cd writers_unblocked
mix deps.get
cd assets && npm install && node node_modules/brunch/bin/brunch build
cd ..

mix ecto.create
mix ecto.migrate

#populate database with a few entries
mix run priv/repo/seeds.exs

