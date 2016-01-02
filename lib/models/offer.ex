defmodule Stockranger.Models.Offer do
  @derive [Poison.Encoder]
  defstruct [:price, :quantity, :type]

  def create_offers(nil) do
    []
  end

  def create_offers(data) do
    Enum.map(data, &create/1)
  end

  # TODO: update to use map module

  def create(data = %{"isBuy" => true}) do
    create(%{data | "isBuy" => :bid})
  end

  def create(data = %{"isBuy" => false}) do
    create(%{data | "isBuy" => :ask})
  end

  def create(data) do
    %Stockranger.Models.Offer{
      price:    data[ "price" ],
      quantity: data[ "qty"   ],
      type:     data[ "isBuy" ]
    }
  end
end
