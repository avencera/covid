defmodule CovidWeb.LayoutView do
  use CovidWeb, :view

  def active(conn, string, active, inactive \\ "") do
    do_active(conn.request_path, string, active, inactive)
  end

  defp do_active(same, same, class, _inactive_class), do: class
  defp do_active(_same, _not_same, _class, inactive_class), do: inactive_class
end
