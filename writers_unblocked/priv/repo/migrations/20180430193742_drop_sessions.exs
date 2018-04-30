defmodule WritersUnblocked.Repo.Migrations.DropSessions do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      remove :session
      add :locked, :bool
    end
    drop table(:sessions)
  end
end
