defmodule KiteConnectEx.Request do
  @moduledoc """
  A wrapper around `HTTPoison` to provide a basic HTTP interface to communicate
  with KiteConnect APIs
  """

  alias KiteConnectEx.Response

  @api_version 3
  @default_headers [{"X-Kite-version", @api_version}]
  @form_encoded_headers [{"Content-Type", "application/x-www-form-urlencoded"}]

  @request_options [
    timeout: 5_000,
    recv_timeout: 5_000
  ]

  @spec api_version() :: String.t()
  def api_version, do: @api_version

  @spec get_csv(String.t(), map() | nil, list, list) :: Response.success() | Response.error()
  def get_csv(path, query, headers, opts \\ []) do
    HTTPoison.get(
      build_url(path, query),
      build_headers(headers),
      request_options(opts)
    )
    |> parse_csv_response()
  end

  @spec get(String.t(), map() | nil, list, list) :: Response.success() | Response.error()
  def get(path, query, headers, opts \\ []) do
    HTTPoison.get(
      build_url(path, query),
      build_headers(headers),
      request_options(opts)
    )
    |> parse_response()
  end

  @spec delete(String.t(), map() | nil, list, list) :: Response.success() | Response.error()
  def delete(path, query, headers, opts \\ []) do
    HTTPoison.delete(
      build_url(path, query),
      build_headers(headers),
      request_options(opts)
    )
    |> parse_response()
  end

  @spec post(String.t(), map(), list, list) :: Response.success() | Response.error()
  def post(path, body, headers, opts \\ []) do
    HTTPoison.post(
      build_url(path, nil),
      format_body(body),
      build_headers(headers ++ @form_encoded_headers),
      request_options(opts)
    )
    |> parse_response()
  end

  @spec put(String.t(), map(), list, list) :: Response.success() | Response.error()
  def put(path, body, headers, opts \\ []) do
    HTTPoison.put(
      build_url(path, nil),
      format_body(body),
      build_headers(headers ++ @form_encoded_headers),
      request_options(opts)
    )
    |> parse_response()
  end

  defp build_url(path, nil) do
    %{
      URI.parse(KiteConnectEx.base_url())
      | path: path
    }
  end

  defp build_url(path, query) do
    %{
      URI.parse(KiteConnectEx.base_url())
      | path: path,
        query: query
    }
  end

  defp build_headers(@default_headers = headers) do
    headers
  end

  defp build_headers(headers) do
    headers ++ @default_headers
  end

  defp format_body(body) when is_map(body) do
    body
    |> Map.to_list()
    |> URI.encode_query()
  end

  defp format_body(body) when is_list(body) do
    URI.encode_query(body)
  end

  defp format_body(body), do: body

  defp request_options([] = _opts), do: @request_options

  defp request_options(opts) when is_list(opts) do
    Keyword.merge(opts, @request_options)
  end

  defp request_options(_opts), do: @request_options

  defp parse_response({:ok, response}) do
    Response.parse_response(response)
  end

  defp parse_csv_response({:ok, response}) do
    Response.parse_csv_response(response)
  end

  defp parse_response({:error, error}) do
    Response.parse_error(error)
  end
end
