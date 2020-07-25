defmodule KiteConnectEx do
  @moduledoc """
  KiteConnectEx is an API client for the KiteConnect API.
  """

  @doc """
  Get KiteConnect api_key

  ## Example

    api_key = KiteConnectEx.api_key()
  """
  @spec api_key() :: String.t()
  def api_key do
    Application.get_env(:kite_connect_ex, :api_key)
  end

  @doc """
  Get KiteConnect api_secret

  ## Example

    api_secret = KiteConnectEx.api_secret()
  """
  @spec api_secret() :: String.t()
  def api_secret do
    Application.get_env(:kite_connect_ex, :api_secret)
  end

  @doc """
  Get KiteConnect request_options

  ## Example

    request_options = KiteConnectEx.request_options()
  """
  @spec request_options() :: List.t()
  def request_options do
    Application.get_env(:kite_connect_ex, :request_options, [])
  end
end
