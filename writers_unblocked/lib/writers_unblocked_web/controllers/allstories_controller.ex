defmodule WritersUnblockedWeb.AllstoriesController do
  use WritersUnblockedWeb, :controller
  alias WritersUnblocked.Repo
  alias WritersUnblocked.Story
  alias Ecto.Adapters.SQL
  require Logger

  def index(conn, _params) do
  	query = "SELECT title FROM stories"

  	allstorieslist = Repo
    |> SQL.query!("""
        SELECT title, body
        FROM stories
        """, [])
    |> Map.fetch(:rows)
    |> elem(1)

    # print_all(allstorieslist)

	# %Postgrex.Result{rows: [row]} = allstorieslist

    # {title, body} = row

    # IO.puts title
    # IO.puts body

    render conn, "index.html", allstorieslist: allstorieslist
  end

  def print_all([head | tail]) do
  	title = Enum.at(head, 0)
  	body = Enum.at(head, 1)
  	IO.puts "Title: " <> title
  	IO.puts "Body: " <> body
  	print_all(tail)
  end

  def print_all([]) do
  	IO.puts "End List"
  end
end
