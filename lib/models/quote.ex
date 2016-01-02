defmodule Stockranger.Models.Quote do
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
