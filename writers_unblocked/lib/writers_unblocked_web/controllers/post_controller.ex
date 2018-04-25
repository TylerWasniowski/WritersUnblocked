defmodule WritersUnblockedWeb.PostController do
  use WritersUnblockedWeb, :controller

  def on_update_submit(conn, %{"append-input" => input} = params) do
    
    IO.puts("params inspection: ")
    IO.inspect(params)

    IO.puts("conn inspection: ")
    IO.inspect(conn)

    cond do
      byte_size(input) == 0 ->
        text conn, "No form data."
      String.printable?(input) ->
        text conn, "You clicked the update story button with form input: " <> input
      true ->
        text conn, "Data contains non-printable chars."
    end

  end
end

#
#printable?(string, counter \\ :infinity)
#	Checks if a string contains only printable characters
