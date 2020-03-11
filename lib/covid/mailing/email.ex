defmodule Covid.Mailing.Email do
  import Bamboo.Email
  use Bamboo.Phoenix, view: CovidWeb.EmailView

  def base_email() do
    new_email()
    |> from(Application.get_env(:covid, :email)[:from])
    |> put_html_layout({CovidWeb.LayoutView, "email.html"})
  end
end
