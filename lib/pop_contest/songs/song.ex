defmodule PopContest.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :artist, :string
    field :tally, :integer
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:title, :artist, :tally])
    |> validate_required([:title, :tally])
  end
end
