defmodule CovidWeb.ErrorView do
  use CovidWeb, :view

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  # hack remove when upgraded to absinthe 500 and changed dataloader to return errors as tuples
  def render("500.json", %{reason: %BadMapError{term: {:error, message}}}) do
    %{errors: %{detail: message}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
