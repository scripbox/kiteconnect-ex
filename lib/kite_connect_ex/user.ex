defmodule KiteConnectEx.User do
  @moduledoc """
  Module to represent a user resource.

  - [Docs](https://kite.trade/docs/connect/v3/user/)
  """

  alias KiteConnectEx.Request

  @login_url "https://kite.zerodha.com/connect/login"
  @create_session_path "/session/token"

  @keys [
    access_token: nil,
    api_key: nil,
    avatar_url: nil,
    broker: nil,
    email: nil,
    exchanges: nil,
    login_time: nil,
    meta: nil,
    order_types: nil,
    products: nil,
    public_token: nil,
    refresh_token: nil,
    silo: nil,
    user_id: nil,
    user_name: nil,
    user_shortname: nil,
    user_type: nil
  ]

  @type t :: %__MODULE__{
          access_token: String.t(),
          api_key: String.t(),
          avatar_url: String.t(),
          broker: String.t(),
          email: String.t(),
          exchanges: List.t(),
          login_time: String.t(),
          meta: map(),
          order_types: List.t(),
          products: List.t(),
          public_token: String.t(),
          refresh_token: String.t(),
          silo: String.t(),
          user_id: String.t(),
          user_name: String.t(),
          user_shortname: String.t(),
          user_type: String.t()
        }

  defstruct [:original_json | @keys]

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

  @doc """
  Generate `access_token` using the `request_token`

  ## Example

    {:ok, user_profile} = KiteConnectEx.User.create_session("request-token")
  """
  @spec create_session(String.t()) :: {:ok, %__MODULE__{}} | Response.error()
  def create_session(request_token) when is_binary(request_token) do
    params = %{
      api_key: api_key(),
      request_token: request_token,
      checksum: generate_checksum(request_token)
    }

    Request.post(@create_session_path, params, [], request_options())
    |> case do
      {:ok, user_data} ->
        user = %__MODULE__{new(user_data) | original_json: user_data}

        {:ok, user}

      {:error, error, status} ->
        {:error, error, status}
    end
  end

  defp generate_checksum(request_token) do
    :crypto.hash(:sha256, api_key() <> request_token <> api_secret())
    |> Base.encode16(case: :lower)
  end

  defp api_secret do
    Application.get_env(:kite_connect_ex, :api_secret)
  end

  defp request_options do
    Application.get_env(:kite_connect_ex, :request_options, [])
  end

  defp new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      access_token: attributes["access_token"],
      api_key: attributes["api_key"],
      avatar_url: attributes["avatar_url"],
      broker: attributes["broker"],
      email: attributes["email"],
      exchanges: attributes["exchanges"],
      login_time: attributes["login_time"],
      meta: attributes["meta"],
      order_types: attributes["order_types"],
      products: attributes["products"],
      public_token: attributes["public_token"],
      refresh_token: attributes["refresh_token"],
      silo: attributes["silo"],
      user_id: attributes["user_id"],
      user_name: attributes["user_name"],
      user_shortname: attributes["user_shortname"],
      user_type: attributes["user_type"]
    })
  end

  defp new(_) do
    struct(__MODULE__, %{})
  end
end
