defmodule WritersUnblocked.Repo.Migrations.Change_Locked_To_Time do
  use Ecto.Migration

  def change do
  	alter table("stories") do
  		add :locked_until, :naive_datetime
  	end
  end
end
