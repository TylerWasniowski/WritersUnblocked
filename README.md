# WritersUnblocked
A collaborative story writing platform written in Elixir using the Phoenix framework.


### Linux build instructions (tested on Linux Mint 18.3)

`esl-erlang` (note the `esl-`) >= 18 and `elixir` >= 1.4 are needed before Phoenix.  
Following the current installation instructions on https://elixir-lang.org/install.html  
for Ubuntu did not install the correct version of elixir and lacked needed erlang components.

I downloaded specific packages from:  
  https://www.erlang-solutions.com/resources/download.html  
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
After that, follow the instructions on Phoenix's website:  
https://hexdocs.pm/phoenix/installation.html#content  

