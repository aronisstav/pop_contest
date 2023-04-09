defmodule PopContestWeb.SongLive.Results do
  use PopContestWeb, :live_view

  @topic "live"
  @presence_topic "pop_contest_presence"

  alias PopContest.Songs
  alias PopContest.Presence
  alias PopContest.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      {:ok, _} = Presence.track(self(), @presence_topic, socket.id, %{})
      Phoenix.PubSub.subscribe(PubSub, @presence_topic)
      PopContestWeb.Endpoint.subscribe(@topic)
    end
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
    |> assign(:presence, get_presence())
  end

  def get_presence() do
    Enum.count(Presence.list(@presence_topic))
  end
end
