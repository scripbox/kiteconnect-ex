defmodule KiteConnectEx.Orders do
  @moduledoc """
  Module to represent a user's orders
  """

  alias KiteConnectEx.Request
  alias KiteConnectEx.Orders.{Order}

  @orders_path "/orders"

  @doc """
  Get all user's `orders`

  ## Example

    {:ok, orders} = KiteConnectEx.Orders.all_orders("access-token")
  """
  @spec all_orders(String.t()) :: {:ok, List.t()} | Response.error()
  def all_orders(access_token) when is_binary(access_token) do
    Request.get(@orders_path, nil, auth_header(access_token), KiteConnectEx.request_options())
    |> case do
      {:ok, orders_data} ->
        {:ok, orders_data}

      {:error, error} ->
        {:error, error}
    end
  end

  defp auth_header(access_token) do
    [{"Authorization", "token " <> KiteConnectEx.api_key() <> ":" <> access_token}]
  end
  
end