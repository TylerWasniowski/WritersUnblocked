import Ecto
import Ecto.Changeset
import Ecto.Query

defmodule WritersUnblocked.Session do
    use Ecto.Schema
    alias WritersUnblocked.Story

    schema "sessions" do
        # Currently these are atomic entries w/o users, etc (just story id)
        #belongs_to :story, WritersUnblocked.Story
    end

    def changeset(session, params \\ %{}) do
        session
        |> cast(params, [:story])
        |> foreign_key_constraint(:story) # This might be redundant but I'm not sure
    end
end
