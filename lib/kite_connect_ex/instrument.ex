defmodule KiteConnectEx.Instrument do
  @moduledoc """
  Module to retrieve a list of tradable `instruments`
  """

  alias KiteConnectEx.Portfolio.Holding
  alias KiteConnectEx.Request

  @instruments_base_path "/instruments"

  @doc """
  Get all tradable `instruments` by `exchange`

  ## Example

    {:ok, instruments} = KiteConnectEx.Portfolio.instruments("access-token", "NSE")
  """
  @spec instruments(String.t(), String.t()) :: {:ok, List.t()} | Response.error()
  def instruments(access_token, exchange) when is_binary(access_token) do
    Request.get(
      instruments_path(exchange),
      nil,
      auth_header(access_token),
      KiteConnectEx.request_options()
    )
    |> case do
      {:ok, instruments_csv_dump} ->
        {:ok, instruments_csv_dump}

      {:error, error} ->
        {:error, error}
    end
  end

  defp instruments_path(exchange) do
    @instruments_base_path <> "/" <> exchange
  end

  defp auth_header(access_token) do
    [{"Authorization", "token " <> KiteConnectEx.api_key() <> ":" <> access_token}]
  end
end
