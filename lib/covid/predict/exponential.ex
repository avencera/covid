defmodule Covid.Predict.Exponential do
  alias Covid.Predict.Exponential.Py
  alias Statistics.Math

  @type(type :: :exponential, :weighted_exponential)

  defmodule Model do
    @type t :: %Model{
            a: float,
            b: float
          }
    @enforce_keys [:factors, :results, :a, :b]
    defstruct [:factors, :results, :a, :b]
  end

  @spec fit({[pos_integer()], [pos_integer()]}, type) :: Model.t()
  def fit({[], []}, _type), do: {:error, "Must have factors and results"}
  def fit({_, []}, _type), do: {:error, "Must have results"}
  def fit({[], _}, _type), do: {:error, "Must have factors"}

  def fit({x, y}, type) do
    with {:ok, [b, a]} <-
           Py.fit(x, y, type) do
      {:ok, %Model{a: a, b: b, factors: x, results: y}}
    else
      e -> {:error, "Unable to create model: #{inspect(e)}"}
    end
  end

  @spec predict({:ok, Model.t()} | {:error, String.t() | %Model{}}, pos_integer()) ::
          pos_integer()
  def predict({:ok, %Model{} = model}, x) do
    predict(model, x)
  end

  def predict({:error, msg}, _) do
    0
  end

  def predict(%Model{} = model, x) do
    Math.exp(model.a) * Math.exp(model.b * x)
  end
end
