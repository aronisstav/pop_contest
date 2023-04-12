defmodule PopContest.Repo.Migrations.AddArtist do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :artist, :string
    end
  end
end
