defmodule KiteConnectEx do
  alias KiteConnectEx.{User, Response, Portfolio, Instrument}

  @api_url "https://api.kite.trade"

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

  @doc """
  Get KiteConnect API base_url

  ## Example

    base_url = KiteConnectEx.base_url()
  """
  @spec base_url() :: String.t()
  def base_url do
    Application.get_env(:kite_connect_ex, :base_url, @api_url)
  end

  @doc """
  Get KiteConnect login endpoint

  ## Example

    {:ok, url} = KiteConnectEx.get_login_url(%{foo: "bar"})
  """
  @spec get_login_url(map) :: {:ok, String.t()}
  defdelegate get_login_url(params), to: User

  @doc """
  Generate `access_token` using the `request_token`

  ## Example

    {:ok, user_profile} = KiteConnectEx.create_session("request-token")
  """
  @spec create_session(String.t()) :: {:ok, %User{}} | Response.error()
  defdelegate create_session(request_token), to: User

  @doc """
  Get user's portfolio `holdings`

  ## Example

    {:ok, holdings} = KiteConnectEx.holdings("access-token")
  """
  @spec holdings(String.t()) :: {:ok, List.t()} | Response.error()
  defdelegate holdings(access_token), to: Portfolio

  @doc """
  Get list of all tradable `instruments` by `exchange`

  ## Example

    {:ok, instruments} = KiteConnectEx.instruments("access-token")
  """
  @spec instruments(String.t(),String.t()) :: {:ok, List.t()} | Response.error()
  defdelegate instruments(access_token, exchange), to: Instrument
end
