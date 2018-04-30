import Ecto.Query, only: [from: 2]

defmodule WritersUnblockedWeb.PostController do
  use WritersUnblockedWeb, :controller

  def on_update_submit(conn, %{"append-input" => input, "story-id" => storyid} = params) do
    
    IO.puts("params inspection: ")
    IO.inspect(params)

    IO.puts("conn inspection: ")
    IO.inspect(conn)

    cond do
      byte_size(input) == 0 ->
        text conn, "No form data."
      String.printable?(input) ->
        aquery = from s in "stories", where: s.title == ^storyid, select: s.body # makes a query statement, similar to SQL
        astory = WritersUnblocked.Repo.all(aquery) # Queries the database, from the "stories" table

        storyitem = List.first(astory) # gets the story text from said item

        if (storyitem == nil) do # checks if the story is already in the database
          newstory = %WritersUnblocked.Story{title: storyid, body: input}
          WritersUnblocked.Repo.insert(newstory)
          text conn, "Added Story to Database. You clicked the update story button with form input: " <> input
        else
          text conn, "Found something: " <> storyitem
        end
        text conn, "testing printable"
      true ->
        text conn, "Data contains non-printable chars."
    end

  end
end

#
#printable?(string, counter \\ :infinity)
#	Checks if a string contains only printable characters
