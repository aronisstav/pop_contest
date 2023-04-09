defmodule PopContest.Presence do
  use Phoenix.Presence,
    otp_app: :pop_contest,
    pubsub_server: PopContest.PubSub
end
