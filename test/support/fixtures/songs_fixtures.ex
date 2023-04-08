defmodule PopContest.SongsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PopContest.Songs` context.
  """

  @doc """
  Generate a song.
  """
  def song_fixture(attrs \\ %{}) do
    {:ok, song} =
      attrs
      |> Enum.into(%{
        tally: 42,
        title: "some title"
      })
      |> PopContest.Songs.create_song()

    song
  end
end
