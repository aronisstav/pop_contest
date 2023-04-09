defmodule PopContestWeb.SongLive.Index do
  use PopContestWeb, :live_view

  alias PopContest.Songs
  alias PopContest.Songs.Song

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :songs, Songs.list_songs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Song")
    |> assign(:song, Songs.get_song!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Song")
    |> assign(:song, %Song{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Songs")
    |> assign(:song, nil)
  end

  @impl true
  def handle_info({PopContestWeb.SongLive.FormComponent, {:saved, song}}, socket) do
    PopContestWeb.Endpoint.broadcast_from(self(), @topic, "vote", :foo)
    {:noreply, stream_insert(socket, :songs, song)}
  end
  def handle_info(_, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    song = Songs.get_song!(id)
    {:ok, _} = Songs.delete_song(song)
    PopContestWeb.Endpoint.broadcast_from(self(), @topic, "vote", :foo)
    {:noreply, stream_delete(socket, :songs, song)}
  end
end
