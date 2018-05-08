import Ecto
import Ecto.Changeset
import Ecto.Query

defmodule WritersUnblocked.Story do
    use Ecto.Schema

    schema "stories" do
        field :title, :string
        field :body, :string
        field :locked_until, :naive_datetime
        field :finished, :boolean
        field :votes, :integer
    end

    def changeset(story, params \\ %{}) do
        story
        |> cast(params, [:title, :body, :locked_until, :finished, :votes])
    end
end
