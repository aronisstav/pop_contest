defmodule PopContestWeb.SongLive.Vote do
  use PopContestWeb, :live_view

  alias PopContest.Songs

  @topic "live"

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true -> {:ok, assign(socket, :songs, Songs.sample_songs())}
      false -> {:ok, assign(socket, :songs, [])}
    end
  end

  @impl true
  def handle_event("vote", %{"id" => id}, socket) do
    %{:tally => tally} = song = Songs.get_song!(id)
    {:ok, _} = Songs.update_song(song, %{:tally => tally + 1})
    PopContestWeb.Endpoint.broadcast_from(self(), @topic, "vote", :foo)
    {:noreply, socket}
  end
  def handle_event("refresh", _, socket) do
    {:noreply, assign(socket, :songs, Songs.sample_songs())}
  end
end
