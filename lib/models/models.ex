defmodule Stockranger.Models do
  defmacro __using__(_) do
    quote do
      alias Stockranger.Models.Offer
      alias Stockranger.Models.OrderBook
      alias Stockranger.Models.Order
      alias Stockranger.Models.OrderStatus
      alias Stockranger.Models.Quote
      alias Stockranger.Models.Stock
    end
  end
end
