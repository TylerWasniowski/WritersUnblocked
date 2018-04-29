# Stub functions that may be needed to call on data.
# Feel free to modify/remove any of them or add more.
# Same for any of the "structs"
#
# This module could encapsulate an "actual" database,
# custom data structures, or a mix of thw two.
#  
# For this assignment, dont worry if we we dont get session id's
# or exclusive access to stories correct, or even implemented at all. 
#
#
# Perhaps doesn't make sense to pass whole conn param here,
# but some logic/state with that prob needs get updated too at some point.

defmodule Data do
  
  #maybe it makes sense to send id as a string, for viewing purposes?

  defmodule Info do
    defstruct id: 0, title: ""
  end

  defmodule UserStory do
    defstruct id: 0, title: "", body: ""
  end

  # this structs name is %Data{} ? Can have two structs per module?
  # https://elixirforum.com/t/elixir-structs/4865/2
  # defstruct name: "John", age: 27 

  def create_new_story(_conn, title, body) do
    IO.puts "creating story.\ntitle: " <> title <> "\nbody: " <> body
    :ok
  end

  def acquire_any_unfinished_story(_conn) do
    IO.puts "giving out (exclusive?) edit access to story"
    %UserStory{id: 7, title: "Title of random story", body: "It was a dark and stormy night..."}
  end

  def release_and_update_story(_conn, appendstr, isfinal) do # bool, true if should complete story
    IO.puts "will append data: " <> appendstr
    if isfinal do
      IO.puts "will verify story can be final (sufficient length?), and update"
    else
      IO.puts "just appending to story"
    end
  end

  #view a finished by its id. "How I saw this good one the other day, its id is: x"
  def view_by_id(pickedid) do
    %UserStory{id: pickedid, title: "Title of finsihed specifc", body: "Body of finished specific"}
  end

  # I think upvotes can be a stretch goal also, either way dont worry about any kind of manipulation or multiple
  # votes from same person.

  # id is the id the user clicked on when browsing, user should own no story when browsing
  def upvote_story_by_id(_conn, id) do
    IO.puts "upvoting story with id #{id}"
    :ok
  end

  # def get_top_ranked_info(r)
  # something akin to: 
  # SELECT title FROM story WHERE rank=r AND rank<r+10
  # returns (up to, if not enough in storage) information of 10 stories, starting at rank r
  # returns list/binary/array of info, lemgth
  # this can be stretch goal, have simple look up by id first.

  def get_top_ranked_info(_r) do
    [%Info{id: 1, title: "The Adventures of Bob"}, %Info{id: 2, title: "Cool Title Here"}]
  end

end


"""

# then when in iex, "r Data" to reload module
iex(1)> import_file("data.ex")                 
{:module, Data,
 <<70, 79, 82, 49, 0, 0, 13, 164, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 2, 16,
   131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115,
   95, 118, 49, 108, 0, 0, 0, 4, 104, 2, ...>>, {:upvote_story_by_id, 2}}
iex(3)> x = %Data.Info{id: 0, title: "123"}
%Data.Info{id: 0, title: "123"}
iex(4)> x.id
0
iex(5)> x.title
"123"
iex(5)> <<canHaveBinOfStruct, _r>> = << %Data.Info{id: 0, title: "123"}, %Data.Info{id: 1, title: "xyz"} >>
** (ArgumentError) argument error

iex(6)>  info = Data.get_top_ranked_info(345)
[%Data.Info{id: 1, title: "The Adventures of Bob"},
 %Data.Info{id: 2, title: "Cool Title Here"}]
iex(7)> [h|t] = info
iex(8)> h
%Data.Info{id: 1, title: "The Adventures of Bob"}
iex(9)> h.title
"The Adventures of Bob"

"""