# If want to try code reuse for create new story and update story html web pages,
# can look at phoenix "views": https://hexdocs.pm/phoenix/views.html
# 
# But I think there both small with enough differences to have them separate templates. 


defmodule WritersUnblockedWeb.PostController do
  use WritersUnblockedWeb, :controller

  # def on_update_submit(conn, %{"append-input" => input, "isfinal" => isfin} = params) do
  def on_update_submit(conn, %{"append-input" => input} = params) do

  	isfin = false # dont know how to send extra data with html...

    IO.puts("params inspection: ")
    IO.inspect(params)

    IO.puts("conn inspection: ")
    IO.inspect(conn)

    Data.release_and_update_story(conn, input, isfin)

    cond do
      byte_size(input) == 0 ->
        text conn, "No form data."
      String.printable?(input) -> # this check should be above the Data.()
        text conn, "You clicked the update story button with form input: " <> input
      true ->
        text conn, "Data contains non-printable chars."
    end
  end

  def on_create_submit(conn, %{"title" => title, "body" => body} = params) do
  	IO.puts("params inspection: ")
    IO.inspect(params)

    Data.create_new_story(conn, title, body)
    text conn, "we got your submission for new story: " <> title <> ". body: " <> body
  end


  # def on_view_by_rank(conn, %{"pageno" => pageno} = _params) do
  #   [h|_t] = Data.get_top_ranked_info((pageno-1)*10) #
  #   text conn, "see titles of top ranked: " <> h.title
  # end

  def on_view_by_id(conn, %{"input" => id} = _params) do
  	{pint, atm} = Integer.parse(id)
  	if (atm===:error) do
  	  IO.puts "parse int #{id} invalid"
  	  text conn, "bad id"
  	else
	  x = Data.view_by_id(pint) # maybe error also...
	  text conn, "Components of story id #{pint}: " <> x.title <> "\n\n" <> x.body
	end
  end
end

#
#printable?(string, counter \\ :infinity)
#	Checks if a string contains only printable characters
