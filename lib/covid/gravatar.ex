defmodule Covid.Gravatar do
  @spec url(struct() | String.t() | map()) :: String.t()
  def url(user) when is_struct(user) do
    user
    |> Map.from_struct()
    |> url()
  end

  def url(%{email: email, first_name: first_name, last_name: last_name}),
    do: url(email, first_name, last_name)

  def url(%{email: email}), do: url(email)
  def url(email), do: do_url(email)

  @spec url(String.t(), String.t() | nil) :: String.t()
  def url(email, name), do: do_url(email, name)

  @spec url(String.t(), String.t() | nil, String.t() | nil) :: String.t()
  def url(email, nil, nil), do: do_url(email)
  def url(email, first_name, last_name), do: do_url(email, "#{first_name}+#{last_name}")

  defp do_url(email, name \\ nil)
  defp do_url(email, "+"), do: do_url(email)
  defp do_url(email, ""), do: do_url(email)
  defp do_url(email, nil), do: do_url(email, email)

  defp do_url(email, name) do
    {bg, text} = random_colors()

    Exgravatar.gravatar_url(email,
      size: 128,
      default: "https://ui-avatars.com/api/#{name}/128/#{bg}/#{text}"
    )
  end

  defp random_colors() do
    tailwind_colors = Covid.Tailwind.colors()

    color =
      tailwind_colors
      |> Map.keys()
      |> Enum.shuffle()
      |> List.first()

    selected_color = Map.get(tailwind_colors, color)

    {selected_color."200", selected_color."900"}
  end
end
