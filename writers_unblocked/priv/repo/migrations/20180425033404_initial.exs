defmodule WritersUnblocked.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :title, :string
      add :body, :string
    end
    create table(:sessions) do
      add :story, references(:stories)
    end
  end
end
