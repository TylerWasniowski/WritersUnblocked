import Ecto
import Ecto.Changeset
import Ecto.Query

defmodule WritersUnblocked.Session do
    use Ecto.Schema

    schema "sessions" do
        # Currently these are atomic entries w/o user or story ids
        belongs_to :story, Story
    end

    def changeset(session, params \\ %{}) do
        session
        |> cast(params, [:story])
        |> foreign_key_constraint(:story) # This might be redundant but I'm not sure
    end
end
