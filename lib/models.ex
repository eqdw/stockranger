defmodule Stockranger.Models do
  defmacro __using__(_) do
    quote do
      alias Stockranger.Models.Stock
      alias Stockranger.Models.OrderBook
      alias Stockranger.Models.Order
      alias Stockranger.Models.Quote
    end
  end

  defmodule Quote do
    alias Stockranger.Models.Quote
    alias Stockranger.Models.Stock

    defstruct [:stock, :bid, :ask, :bid_size, :ask_size,
      :bid_depth, :ask_depth, :last, :last_size, :last_trade,
      :quote_time]

    def create(data) do
      %Quote{
        stock: Stock.create(data),
        bid:        data["bid"],      ask:       data["ask"],
        bid_size:   data["bidSize"],  ask_size:  data["askSize"],
        bid_depth:  data["bidDepth"], ask_depth: data["askDepth"],
        last:       data["last"],     last_size: data["lastSize"],
        last_trade: data["last_trade"],
        quote_time: data["quote_time"]
      }
    end
  end

  defmodule Stock do
    @derive [Poison.Encoder]
    defstruct [:name, :symbol, :venue]

    def create(data, venue) do
      create( Map.put_new(data, "venue", venue) )
    end

    def create(data) do
      %Stockranger.Models.Stock{
        name:   data[ "name"   ],
        symbol: data[ "symbol" ],
        venue:  data[ "venue"  ]
      }
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

