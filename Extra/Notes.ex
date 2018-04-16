#[ ] is like list
#can "overload" on a specific runtime value of a type, eg: a list with a head vs an empty list
#  or fib(0), fib (1), fib(n), where n>1
#?a is the (integer?) literal ascii of a
#'abc' is a charlist [97,98,99]

#"abc" is a binary

#pattern matching
#[head|rest] = list
#<<a, b>> = <<1,2>> will result in assigning 1 to a and 2 to b
#<< >> is an array of bytes, can interperet/pattern match however you want (even at bit level?)
#  "binary constructor"
#  a binary unit is 8 bits
#  <> is bin concat, only works if both are binarys
#
#more pattern matching which case statement

#no god damn real multiple line comments, but can do python style string abuse

#fn a, b -> a + b end
#same as:
#&(&1+&2)

#Don't know why I decided to write atoi, not really relevant an ddoesnt seem to fit elixir well.
#  If wanted to sum all ints in a textfile, probably
#  more elixir-y to do something like split |> parse |> fold, or however thats done.

defmodule Notes do
	def atoi(<<head::unsigned-integer-8>>, accum) do
		d = head - 48
		if d>=0 and d<10 do
			{<<head>>, accum*10 + d}
		else
			{<<head>>, accum}
		end
	end

	def atoi(<<head::unsigned-integer-8, rest::bytes>>, accum) do
		d = head - 48
		if d>=0 and d<10 do
			atoi(rest, accum*10 + d)
		else
			{<<head>> <> rest, accum}
		end
	end

	def atoi_v2(a, accum) do
		case a do
			<<head::unsigned-integer-8, rest::bytes>> ->
				d = head - 48
				if d<10 and d>=0 do
					atoi_v2(rest, accum*10 + d)
				else
					{a, accum}
				end
			_ -> {a, accum}
		end
	end

	def main() do
		IO.puts "Hello!"
		a = atoi(<<"123", 0>>, 0)
		b = atoi(<<"321", "xyz">>, 0)

		IO.puts(elem(a, 1) + elem(b, 1))
		IO.puts(elem(b, 0))
		IO.puts byte_size("abc")

		atoi_v2(<<"511", 0>>, 0) |> elem(1) |> Kernel.*(3) |> IO.puts
	end
end

Notes.main()
#output:
#  Hello!
#  444
#  xyz
#  3
#  1533


#not very helpuful error messages...
#** (ArgumentError) argument error
#    Notes.ex:57: Notes.atoi_v2/2
#    Notes.ex:70: Notes.main/0
#    (elixir) lib/code.ex:363: Code.require_file/2
