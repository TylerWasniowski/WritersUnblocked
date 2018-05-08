defmodule WritersUnblocked.Repo.Migrations.Add_Vote_Column do
  use Ecto.Migration

  def change do
    alter table(:stories) do
      add(:votes, :integer, default: 0, null: false)
    end
  end
end
