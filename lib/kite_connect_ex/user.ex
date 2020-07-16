defmodule KiteConnectEx.User do
  @moduledoc """
  Module to represent a user resource.

  - [Docs](https://kite.trade/docs/connect/v3/user/)
  """

  alias KiteConnectEx.Request

  @login_url "https://kite.zerodha.com/connect/login"

  @doc """
  Get KiteConnect login endpoint

  ## Example

    {:ok, url} = KiteConnectEx.User.get_login_url()
  """
  @spec get_login_url() :: {:ok, String.t()}
  def get_login_url do
    query = URI.encode_query(%{v: Request.api_version(), api_key: api_key()})
    login_url = @login_url <> "?" <> query

    {:ok, login_url}
  end

  defp api_key do
    Application.get_env(:kite_connect_ex, :api_key)
  end
end
