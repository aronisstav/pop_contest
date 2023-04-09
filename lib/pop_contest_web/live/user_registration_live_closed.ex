defmodule PopContestWeb.UserRegistrationClosedLive do
  use PopContestWeb, :live_view

  def render(assigns) do
    ~H"""
    Registrations are closed :-/
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
