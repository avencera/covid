defmodule Covid.Predict.Exponential.Py do
  def fit(x, y, type) do
    x = Enum.join(x, ",")
    y = Enum.join(y, ",")

    with {json, 0} <- System.cmd(python(), [script(type), x, y]),
         {:ok, list} <- Jason.decode(json) do
      {:ok, list}
    end
  end

  def python() do
    System.find_executable("python3")
  end

  def script(:exponential), do: Application.app_dir(:covid, "priv/python/regression.py")

  def script(:weighted_exponential),
    do: Application.app_dir(:covid, "priv/python/weighted_regression.py")
end
