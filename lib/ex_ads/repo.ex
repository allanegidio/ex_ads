defmodule ExAds.Repo do
  use Ecto.Repo,
    otp_app: :ex_ads,
    adapter: Ecto.Adapters.Postgres
end
