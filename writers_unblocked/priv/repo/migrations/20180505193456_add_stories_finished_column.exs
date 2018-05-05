defmodule WritersUnblocked.Repo.Migrations.AddStoriesFinishedColumn do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      add :finished, :boolean, default: "false", null: false
    end
  end
end
