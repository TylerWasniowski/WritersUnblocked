# https://hexdocs.pm/phoenix/views.html
# 
# Functions here can be accessed in the corresponding .eex file via <%= funcname() %>
# 
# Alternatively, data such as strings can be sent as an assign and accessed via <%= @val %>
# render/3 last param is an assigns map, which can be constructed va-args style (I think)
# In controller:
# 	render conn, "index.html", title: story_title, body: story_text
#	In eex:
#		<%= @title %>

defmodule WritersUnblockedWeb.StoryView do
  use WritersUnblockedWeb, :view
end
