defmodule WritersUnblocked.Repo do
  use Ecto.Repo, otp_app: :writers_unblocked

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  def init(_, opts) do
    # I think this gets overrided by config in dev.ex / prod.ex
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
