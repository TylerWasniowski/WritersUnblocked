defmodule WritersUnblockedWeb.StoryController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Session
  require Logger

  def index(conn, params) do
    if get_session(conn, :session_id) do
      render conn, "index.html"
    else
      # Make a new session in the database, and save the id
      session_id = %Session{}
      |> Repo.insert
      |> elem(1)
      |> Map.fetch(:id)
      |> elem(1)

      Logger.debug "Created session with id: #{session_id}"

      conn
      |> put_session(:session_id, session_id)
      |> render("index.html")
    end

    params
    |> Map.fetch("action")
    |> elem(1)
    |> Logger.debug

    story_text = "PLACEHOLDER"
    #JON'S CODE HERE


    render conn, "index.html"
  end

  def submit_entry(conn, %{"append-input" => input} = params) do

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
