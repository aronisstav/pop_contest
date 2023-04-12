defmodule PopContestWeb.SongLive.Vote do
  use PopContestWeb, :live_view

  @topic "live"
  @presence_topic "pop_contest_presence"

  alias PopContest.Songs
  alias PopContest.Songs.Song
  alias PopContest.Presence
  alias PopContest.PubSub

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
      true ->
        {:ok, _} = Presence.track(self(), @presence_topic, socket.id, %{})
        Phoenix.PubSub.subscribe(PubSub, @presence_topic)
        {:ok, update(socket, Songs.sample_songs())}
      false -> {:ok, update(socket, [%Song{:title => "Loading..."}])}
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
    {:noreply, update(socket, Songs.sample_songs())}
  end

  def update(socket, songs) do
    socket
    |> assign(:songs, songs)
    |> assign(:presence, get_presence())
    |> assign(:page_title, "Voting")
  end

  def get_presence() do
    Enum.count(Presence.list(@presence_topic))
  end

end
