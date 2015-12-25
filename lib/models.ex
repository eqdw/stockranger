defmodule Stockranger.Models do
  defmacro __using__(_) do
    quote do
      alias Stockranger.Models.Stock
      alias Stockranger.Models.OrderBook
      alias Stockranger.Models.Order
    end
  end

  defmodule Stock do
    @derive [Poison.Encoder]
    defstruct [:name, :symbol]

    def create(data) do
      %Stockranger.Models.Stock{name: data["name"], symbol: data["symbol"]}
    end
  end

  defmodule OrderBook do
    defstruct venue: nil, bids: [], asks: [], timestamp: nil, stock: %Stockranger.Models.Stock{}

    def create(data) do
      %Stockranger.Models.OrderBook{venue: data["venue"],
        stock: Stockranger.Models.Stock.create(data),
        bids: Stockranger.Models.Order.create_orders( data["bids"] ),
        asks: Stockranger.Models.Order.create_orders( data["asks"] ),
        timestamp: data["ts"]}
    end
  end

  defmodule Order do
    @derive [Poison.Encoder]
    defstruct [:price, :quantity, :type]

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
      %Stockranger.Models.Order{price: data["price"], quantity: data["qty"], type: data["isBuy"]}
    end
  end
end

