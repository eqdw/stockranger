#defmodule Stockranger.Response do
  #defstruct
#end

defmodule Stockranger.Api do

  @api_base "https://api.stockfighter.io/ob/api"

  def heartbeat do
    %{data: data} = get("/heartbeat")
    data["ok"]
  end

  def heartbeat(venue) do
    %{data: data} = get("/venues/#{venue}/heartbeat")
    data["ok"]
  end

  def stocks(venue) do
    %{data: data} = get("/venues/#{venue}/stocks")

    case data do
      %{"ok" => true, "symbols" => symbols} ->
        Enum.map(symbols, fn(stock) -> Stockranger.Stock.create(stock) end)
      %{"ok" => false, "error" => error} ->
        error
    end
  end

  def order_book(venue, stock) do
    %{data: data} = get("/venues/#{venue}/stocks/#{stock}")

    case data do
      %{"ok" => true} ->
        Stockranger.OrderBook.create(data)
      %{"ok" => false, "error" => error} ->
        error
    end
  end

  def post(url) do
  end

  def get(url) do
    HTTPoison.get("#{@api_base}#{url}")
    |> process_response
  end

  defp process_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status, body: body}} ->
        %{status: status, data: Poison.decode!(body)}
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
