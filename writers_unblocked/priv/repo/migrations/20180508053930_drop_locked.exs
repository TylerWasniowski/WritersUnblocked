defmodule WritersUnblocked.Repo.Migrations.DropLocked do
  use Ecto.Migration

  def change do
  	alter table("stories") do
      remove :locked
      modify :locked_until, :naive_datetime, null: false, default: "1970-01-01 00:00:00"
  	end
  end
end
