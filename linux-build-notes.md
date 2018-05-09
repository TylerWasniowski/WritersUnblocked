Tested on Linux Mint 18.3 x64

These notes accompany the build script file, which could perhaps be more automated, but I tried my best with my current Linux knowledge.  

This walks through what the script does, some steps can done in a different way or manually.  

Consult https://hexdocs.pm/phoenix/installation.html content if there are any issues,
or customize the steps of the build for your system if need be.

# 0: Before running the script: please make a postgress account with name "postgres", password "postgres" admin privileges.  

#### 1: esl-erlang and elixir

`esl-erlang` (note the `esl-`) >= 18 and `elixir` >= 1.4 are needed before Phoenix.  
Following the current installation instructions on https://elixir-lang.org/install.html  
for Ubuntu did not install the correct version of elixir and lacked needed erlang components (maybe it will for you?).

I downloaded specific packages from:  
  https://www.erlang-solutions.com/resources/download.html  
You might have to get a different version, the script will do a `wget` of the two below:
Install esl-erlang first, then elixir:  
```
$ sudo gdebi esl-erlang_19.0-1ubuntuxenial_amd64.deb
#...
$ sudo gdebi elixir_1.4.2-1ubuntuxenial_amd64.deb
#...
$ elixir -v
Erlang/OTP 19 [erts-8.0] [source-6dc93c1] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

Elixir 1.4.2
$
```
#### 2: mix stuff


#### 3: run
`mix phx.server` in the `writers_unblocked` directory will create the server process.  
Then go to http://localhost:4000/  


```
#!/bin/bash
set -e


#should the script fail midway, would be good to skip this begin part and jump to middle, dunno how to do that right now.
wget https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_19.0-1~ubuntu~xenial_amd64.deb
wget https://packages.erlang-solutions.com/erlang/elixir/FLAVOUR_2_download/elixir_1.4.2-1~ubuntu~xenial_amd64.deb

sudo gdebi esl-erlang_19.0-1ubuntuxenial_amd64.deb
sudo gdebi elixir_1.4.2-1ubuntuxenial_amd64.deb

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

```



