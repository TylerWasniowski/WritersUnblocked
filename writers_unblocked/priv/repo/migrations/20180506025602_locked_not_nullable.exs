defmodule WritersUnblocked.Repo.Migrations.LockedNotNullable do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      modify :locked, :boolean, null: false, default: false
    end
  end
end
