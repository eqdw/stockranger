defmodule Stockranger.Stock do
  defstruct name: nil, symbol: nil

  def create(data) do
    %Stockranger.Stock{name: data["name"], symbol: data["symbol"]}
  end
end

defmodule Stockranger.Order do
  defstruct price: nil, quantity: nil, type: nil

  def create_orders(nil) do
    []
  end
  def create_orders(data) do
    Enum.map(data, &create/1)
  end

  def create(data = %{"isBuy" => true}) do
    create(%{data | "isBuy" => :buy})
  end

  def create(data = %{"isBuy" => false}) do
    create(%{data | "isBuy" => :sell})
  end

  def create(data) do
    %Stockranger.Order{price: data["price"], quantity: data["qty"], type: data["isBuy"]}
  end
end

defmodule Stockranger.OrderBook do
  defstruct venue: nil, bids: [], asks: [], timestamp: nil, stock: %Stockranger.Stock{}

  def create(data) do
    %Stockranger.OrderBook{venue: data["venue"],
      stock: Stockranger.Stock.create(data),
      bids: Stockranger.Order.create_orders( data["bids"] ),
      asks: Stockranger.Order.create_orders( data["asks"] ),
      timestamp: data["ts"]}
  end
end
