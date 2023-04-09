defmodule PopContestWeb.SongLive.Results do
  use PopContestWeb, :live_view

  @topic "live"

  alias PopContest.Songs

  @impl true
  def mount(_params, _session, socket) do
    PopContestWeb.Endpoint.subscribe(@topic)
    {:ok, update(socket)}
  end

  @impl true
  def handle_info(_msg, socket) do
    {:noreply, update(socket)}
  end

  def update(socket) do
    songs = Songs.list_songs()
    total = Enum.sum(for song <- songs, do: song.tally)
    socket
    |> assign(:songs, songs)
    |> assign(:total, total)
  end
end
