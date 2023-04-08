defmodule PopContestWeb.SongLiveTest do
  use PopContestWeb.ConnCase

  import Phoenix.LiveViewTest
  import PopContest.SongsFixtures

  @create_attrs %{tally: 42, title: "some title"}
  @update_attrs %{tally: 43, title: "some updated title"}
  @invalid_attrs %{tally: nil, title: nil}

  defp create_song(_) do
    song = song_fixture()
    %{song: song}
  end

  describe "Index" do
    setup [:create_song]

    test "lists all songs", %{conn: conn, song: song} do
      {:ok, _index_live, html} = live(conn, ~p"/songs")

      assert html =~ "Listing Songs"
      assert html =~ song.title
    end

    test "saves new song", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/songs")

      assert index_live |> element("a", "New Song") |> render_click() =~
               "New Song"

      assert_patch(index_live, ~p"/songs/new")

      assert index_live
             |> form("#song-form", song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#song-form", song: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/songs")

      html = render(index_live)
      assert html =~ "Song created successfully"
      assert html =~ "some title"
    end

    test "updates song in listing", %{conn: conn, song: song} do
      {:ok, index_live, _html} = live(conn, ~p"/songs")

      assert index_live |> element("#songs-#{song.id} a", "Edit") |> render_click() =~
               "Edit Song"

      assert_patch(index_live, ~p"/songs/#{song}/edit")

      assert index_live
             |> form("#song-form", song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#song-form", song: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/songs")

      html = render(index_live)
      assert html =~ "Song updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes song in listing", %{conn: conn, song: song} do
      {:ok, index_live, _html} = live(conn, ~p"/songs")

      assert index_live |> element("#songs-#{song.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#songs-#{song.id}")
    end
  end

  describe "Show" do
    setup [:create_song]

    test "displays song", %{conn: conn, song: song} do
      {:ok, _show_live, html} = live(conn, ~p"/songs/#{song}")

      assert html =~ "Show Song"
      assert html =~ song.title
    end

    test "updates song within modal", %{conn: conn, song: song} do
      {:ok, show_live, _html} = live(conn, ~p"/songs/#{song}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Song"

      assert_patch(show_live, ~p"/songs/#{song}/show/edit")

      assert show_live
             |> form("#song-form", song: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#song-form", song: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/songs/#{song}")

      html = render(show_live)
      assert html =~ "Song updated successfully"
      assert html =~ "some updated title"
    end
  end
end
