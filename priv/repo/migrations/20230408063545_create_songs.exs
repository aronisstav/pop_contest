defmodule PopContest.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :title, :string
      add :tally, :integer

      timestamps()
    end
  end
end
