defmodule PopContest.Repo do
  use Ecto.Repo,
    otp_app: :pop_contest,
    adapter: Ecto.Adapters.Postgres
end
