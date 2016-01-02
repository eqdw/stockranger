defmodule Stockranger.Models.Stock
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
