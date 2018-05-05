#iex> import_file("test.ex")
# reload
# iex> r Test
# ... but doesnt work for me?

defmodule Test do
  def hello() do
    "hello!"
  end

  def casetest(key) do
    case Map.fetch(%{a: "foo", b: "bar"}, key) do
      {:ok, val} -> val
      _ -> ""
    end
  end
  
  # https://elixir-lang.org/getting-started/module-attributes.html#as-constants
  # "As constants"

  # @nocapset %MapSet{"a", "an", "the", "of", "and", "on", "or", "to", "by"} # doesnt work?
  @nocapset MapSet.new(["a", "an", "the", "of", "and", "on", "or", "to", "by"])
  
  def make_proper_title(instr) do
    case String.split(instr, " ", trim: true) do
    [] -> 
      :error # {:error, ""} ????
    [head|rest] -> 
      head = String.capitalize(head)
      if Enum.empty?(rest) do
        head
      else
        head <> " " <> (
        Enum.map(rest, fn(s) ->  if MapSet.member?(@nocapset, s), do: s, else: String.capitalize(s) end) |> Enum.join(" ") )
      end
    end
  end

end

#capitalize(string, mode \\ :default)
#Converts the first character in the given string to uppercase and the remainder to lowercase according to mode
#iex(1)> String.capitalize("xBBBBaB")
#Xbbbbab"

#iex(16)> Test.make_proper_title("    the adventures             of bob   ")
#"The Adventures of Bob"

