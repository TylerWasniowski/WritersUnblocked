defmodule WritersUnblocked.Repo.Migrations.StoryHasSession do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      add :session, references(:sessions)
    end
    alter table(:sessions) do
      remove :story
    end
  end
end
