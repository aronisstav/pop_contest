import Config

config :pop_contest, PopContestWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json",
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  load_from_system_env: true,
  secret_key_base: "${SECRET_KEY_BASE}",
  server: true, # Without this line, your app will not start the web server!
  url: [host: "${APP_NAME}.gigalixirapp.com", port: 443],
  version: Mix.Project.config[:version]

config :pop_contest, PopContest.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "",
  ssl: true,
  pool_size: 2,
  url: "${DATABASE_URL}"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: PopContest.Finch

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
