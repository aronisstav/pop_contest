defmodule PopContestWeb.SongLive.Vote do
  use PopContestWeb, :live_view

  alias PopContest.Songs

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :songs, Songs.sample_songs())}
  end

  @impl true
  def handle_event("vote", %{"id" => id}, socket) do
    %{:tally => tally} = song = Songs.get_song!(id)
    {:ok, newsong} = Songs.update_song(song, %{:tally => tally + 1})
    PopContestWeb.Endpoint.broadcast_from(self(), @topic, "vote", :foo)
    {:noreply, socket}
  end
end
