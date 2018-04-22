#what is the type of conn and params?
#that kind of stuff would help so much


defmodule WritersUnblockedWeb.PostController do
  use WritersUnblockedWeb, :controller
  require Logger

  def on_update(conn, %{"input" => inpt} = params) do # something wrong here...
  	Logger.info(params)

	text conn, "Got your input: " <> inpt # or here...
  end

  def on_create(conn, params) do
  	Logger.info(params)

  	# inpt = elem(Map.fetch(params, "input"), 1)
  	# protocol String.Chars not implemented for %{"input" => "lol"} wtf type is this?
  	# IO.puts "received: " <> inpt # does nothing?

	# {:ok, body, _conn} = Plug.Conn.read_body(conn)

	# IO.puts body

	text(conn, "got your input, just dont know how the hell to pull it out")
  end

  def on_view_id(conn, params) do
  	Logger.info(params)
  	id = elem(Map.fetch(params, "id"), 1)
  end
end

#things to ask:
#get plain data out of whatever type object "params" is
#actually, I think its failing at the start of the function,
#because wth the map and any usage of params removed still get:
#protocol String.Chars not implemented for %{"input" => "dfgdfg"}
