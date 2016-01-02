defmodule Stockranger.Models.OrderBook do
    defstruct venue: nil, bids: [], asks: [], timestamp: nil, stock: %Stockranger.Models.Stock{}

    def create(data) do
      %Stockranger.Models.OrderBook{venue: data["venue"],
        stock: Stockranger.Models.Stock.create(data),
        bids: Stockranger.Models.Offer.create_offers( data["bids"] ),
        asks: Stockranger.Models.Offer.create_offers( data["asks"] ),
        timestamp: data["ts"]}
    end
  end

