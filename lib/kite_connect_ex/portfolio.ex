defmodule KiteConnectEx.Portfolio do
  @moduledoc """
  Module to represent a user's portfolio
  """

  alias KiteConnectEx.Portfolio.Holding
  alias KiteConnectEx.Request

  @holding_path "/portfolio/holdings"

  @doc """
  Get user's portfolio `holdings`

  ## Example

    {:ok, holdings} = KiteConnectEx.Portfolio.holdings("access-token")
  """
  @spec holdings(String.t()) :: {:ok, List.t()} | Response.error()
  def holdings(access_token) when is_binary(access_token) do
    Request.get(@holding_path, nil, auth_header(access_token), KiteConnectEx.request_options())
    |> case do
      {:ok, holdings_data} ->
        holdings = holdings_data |> Enum.map(&Holding.new(&1))

        {:ok, holdings}

      {:error, error} ->
        {:error, error}
    end
  end

  defp auth_header(access_token) do
    [{"Authorization", "token " <> KiteConnectEx.api_key() <> ":" <> access_token}]
  end
end
