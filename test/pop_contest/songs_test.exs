defmodule PopContest.SongsTest do
  use PopContest.DataCase

  alias PopContest.Songs

  describe "songs" do
    alias PopContest.Songs.Song

    import PopContest.SongsFixtures

    @invalid_attrs %{tally: nil, title: nil}

    test "list_songs/0 returns all songs" do
      song = song_fixture()
      assert Songs.list_songs() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture()
      assert Songs.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      valid_attrs = %{tally: 42, title: "some title"}

      assert {:ok, %Song{} = song} = Songs.create_song(valid_attrs)
      assert song.tally == 42
      assert song.title == "some title"
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Songs.create_song(@invalid_attrs)
    end

    test "update_song/2 with valid data updates the song" do
      song = song_fixture()
      update_attrs = %{tally: 43, title: "some updated title"}

      assert {:ok, %Song{} = song} = Songs.update_song(song, update_attrs)
      assert song.tally == 43
      assert song.title == "some updated title"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Songs.update_song(song, @invalid_attrs)
      assert song == Songs.get_song!(song.id)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Songs.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Songs.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Songs.change_song(song)
    end
  end
end
