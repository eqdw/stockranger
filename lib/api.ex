#defmodule Stockranger.Response do
  #defstruct
#end

defmodule Stockranger.Api do
  use Stockranger.Models

  #alias Stockranger.Api
  #alias Stockranger.Stock
  #alias Stockranger.Order

  use HTTPoison.Base

  @api_base "https://api.stockfighter.io/ob/api"

  def heartbeat do
    data = api_get("/heartbeat")
    data["ok"]
  end

  def heartbeat(venue) do
    data = api_get("/venues/#{venue}/heartbeat")
    data["ok"]
  end

  def stocks(venue) do
    data = api_get("/venues/#{venue}/stocks")

    Enum.map(data["symbols"], fn(stock) ->
      Stock.create(stock, venue)
    end)
  end

  def order_book(venue, stock) do
    api_get("/venues/#{venue}/stocks/#{stock}")
    |> OrderBook.create
  end

  def quote(venue, stock) do
    api_get("/venues/#{venue}/stocks/#{stock}/quote")
    |> Quote.create
  end

  def cancel_order(venue, stock, order) do
    api_delete("/venues/#{venue}/stocks/#{stock}/orders/#{order}")
    |> Order.create
  end

  defp api_get(url) do
    %HTTPoison.Response{body: body} = get!(url)
    body
  end

  defp api_post(url, body, headers) do
    %HTTPoison.Response{body: body} = post!(url, body, headers)
  end

  defp api_delete(url) do
    %HTTPoison.Response{body: body} = delete!(url)
  end

  defp process_url(url) do
    @api_base <> url
  end

  defp process_request_body(body) do
    Poison.encode! body
  end

  defp process_request_headers(headers) do
    headers
    |> Keyword.put(:"X-Starfighter-Authorization", Application.get_env(:stockranger, :api_key))
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!
    |> process_stockfighter_response
  end

  defp process_stockfighter_response(%{"ok" => false, "error" => error}) do
    error
  end
  defp process_stockfighter_response(body) do
    body
  end
end
