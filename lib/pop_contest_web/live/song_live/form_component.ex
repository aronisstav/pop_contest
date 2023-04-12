defmodule PopContestWeb.SongLive.FormComponent do
  use PopContestWeb, :live_component

  alias PopContest.Songs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage song records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="song-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:artist]} type="text" label="Artist" />
        <.input field={@form[:tally]} type="number" label="Tally" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Song</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{song: song} = assigns, socket) do
    changeset = Songs.change_song(song)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"song" => song_params}, socket) do
    changeset =
      socket.assigns.song
      |> Songs.change_song(song_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"song" => song_params}, socket) do
    save_song(socket, socket.assigns.action, song_params)
  end

  defp save_song(socket, :edit, song_params) do
    case Songs.update_song(socket.assigns.song, song_params) do
      {:ok, song} ->
        notify_parent({:saved, song})

        {:noreply,
         socket
         |> put_flash(:info, "Song updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_song(socket, :new, song_params) do
    case Songs.create_song(song_params) do
      {:ok, song} ->
        notify_parent({:saved, song})

        {:noreply,
         socket
         |> put_flash(:info, "Song created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
