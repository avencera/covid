defmodule Covid.Predict.Exponential do
  alias Covid.Predict.Exponential.Py
  alias Statistics.Math

  defmodule Model do
    @type t :: %Model{
            a: float,
            b: float
          }
    @enforce_keys [:factors, :results, :a, :b]
    defstruct [:factors, :results, :a, :b]
  end

  @spec fit({[pos_integer()], [pos_integer()]}) :: Model.t()
  def fit({x, y}), do: fit(x, y)

  @spec fit([pos_integer()], [pos_integer()]) :: Model.t()
  def fit(x, y) do
    with {:ok, [b, a]} <- Py.fit(x, y) do
      %Model{a: a, b: b, factors: x, results: y}
    end
  end

  @spec predict(Model.t(), pos_integer()) :: pos_integer()
  def predict(%Model{} = model, x) do
    Math.exp(model.a) * Math.exp(model.b * x)
  end
end
