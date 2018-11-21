defmodule Samlinks.Repo do
  use Ecto.Repo,
    otp_app: :samlinks,
    adapter: Ecto.Adapters.Postgres
end
