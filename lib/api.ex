#defmodule Stockfighter.Response do
  #defstruct
#end

defmodule Stockfighter.Api do
  @heartbeat_url "https://api.stockfighter.io/ob/api/heartbeat"

  def heartbeat do
    case HTTPoison.get(@heartbeat_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)["ok"]
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
end
