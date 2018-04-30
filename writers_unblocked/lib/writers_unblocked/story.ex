import Ecto
import Ecto.Changeset
import Ecto.Query

defmodule WritersUnblocked.Story do
    use Ecto.Schema
    alias WritersUnblocked.Session

    schema "stories" do
        field :title, :string
        field :body, :string
        belongs_to :session, Session
    end

    def changeset(story, params \\ %{}) do
        story
        |> cast(params, [:title, :body])
        |> validate_required([:title, :body])
        |> validate_length(:title, min: 3)
        |> validate_length(:title, max: 42)
        |> validate_length(:body, min: 3)
    end
end
