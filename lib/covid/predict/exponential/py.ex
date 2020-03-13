defmodule Covid.Predict.Exponential.Py do
  def fit(x, y) do
    x = Enum.join(x, ",")
    y = Enum.join(y, ",")

    with {json, 0} <- System.cmd(python(), [script(), x, y]),
         {:ok, list} <- Jason.decode(json) do
      {:ok, list}
    end
  end

  def python() do
    System.find_executable("python3")
  end

  def script() do
    Application.app_dir(:covid, "priv/python/script.py")
  end
end
