defmodule ExAds.Accounts.UserNotifier do
  @view ExAdsWeb.EmailView

  use Phoenix.Swoosh, view: @view, layout: {@view, :layout}

  import Swoosh.Email

  alias ExAds.Mailer

  def email_reset_password_instructions(user, token) do
    url = "/users/reset-password?token=#{token}"

    new()
    |> to({user.first_name, user.email})
    |> from({"ExAds Admin", "admin@exads.com"})
    |> subject("Ex Ads - Reset Password")
    |> render_body("forgot_password_email.html", %{first_name: user.first_name, url: url})
  end

  def send_forgot_password_email(user, token) do
    Task.async(fn ->
      user
      |> email_reset_password_instructions(token)
      |> Mailer.deliver()
    end)
  end
end
