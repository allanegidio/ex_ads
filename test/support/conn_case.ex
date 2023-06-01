defmodule ExAdsWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExAdsWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  alias ExAds.AccountsFixtures
  alias ExAds.Sessions

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ExAdsWeb.ConnCase

      alias ExAdsWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ExAdsWeb.Endpoint
    end
  end

  setup tags do
    ExAds.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  # def include_normal_user_token(%{conn: conn}) do
  #   user = AccountsFixtures.user_fixture()

  #   {:ok, _user_from_token, token} = Sessions.create(user.email, user.password)

  #   {:ok, conn: conn, user: user, token: token}
  # end

  def include_admin_token(%{conn: conn}) do
    user = AccountsFixtures.admin_user_fixture()

    {:ok, _user_from_token, token} = Sessions.create(user.email, user.password)

    conn = Plug.Conn.put_req_header(conn, "authorization", "Bearer" <> token)

    {:ok, conn: conn, user: user, token: token}
  end
end
