defmodule CovidWeb.PageView do
  import PhoenixLiveReact, only: [live_react_component: 2]

  use CovidWeb, :view

  def active(same, same), do: active_button()
  def active(_same, _not_same), do: inactive_button()

  defp active_button(),
    do:
      "bg-indigo-600 border-transparent rounded-md border inline-flex items-center font-medium leading-5 py-2 px-4 text-white text-sm transition ease-in-out duration-150 hover:bg-indigo-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700"

  defp inactive_button(),
    do:
      "bg-indigo-100 border-transparent rounded-md border inline-flex items-center font-medium leading-5 py-2 px-4 text-indigo-700 text-sm transition ease-in-out duration-150 hover:bg-indigo-50 focus:outline-none focus:border-indigo-300 focus:shadow-outline-indigo active:bg-indigo-200"
end
