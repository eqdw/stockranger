defmodule Stockranger.Models.Order do
  alias Stockranger.Models.Order
  alias Stockranger.Models.Stock

  defstruct [
    :stock,     :direction, :quantity,     :original_quantity,
    :price,     :type,      :id,           :account,
    :timestamp, :fills,     :total_filled, :open
  ]

  def create(data) do
    atomized_direction = case data["direction"] do
      "buy"  -> :buy
      "sell" -> :sell
    end

    atomized_type = case data["type"] do
      "limit"               -> :limit
      "market"              -> :market
      "fill-or-kill"        -> :fill_or_kill
      "immediate-or-cancel" -> :immediate_or_cancel
    end

    %Order{
      stock:             Stock.create(data),
      direction:         atomized_direction,
      original_quantity: data[ "originalQty" ],
      quantity:          data[ "qty"         ],
      price:             data[ "price"       ],
      type:              atomized_type,
      id:                data[ "id"          ],
      account:           data[ "account"     ],
      timestamp:         data[ "ts"          ],
      total_filled:      data[ "totalFilled" ],
      open:              data[ "open"        ],
      fills:  Enum.map(data["fills"], fn(fill) ->
        %{price: fill["price"], quantity: fill["qty"], timestamp: fill["ts"]}
      end)
    }
  end
end
