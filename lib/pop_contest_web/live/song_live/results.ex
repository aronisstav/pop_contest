defmodule PopContestWeb.SongLive.Results do
  use PopContestWeb, :live_view

  @topic "live"

  alias PopContest.Songs

  @impl true
  def mount(_params, _session, socket) do
    PopContestWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :songs, Songs.list_songs())}
  end

  @impl true
  def handle_info(_msg, socket) do
    {:noreply, assign(socket, :songs, Songs.list_songs())}
  end

end
