defmodule KiteConnectEx.Response do
  @type http_status_code :: number
  @type success :: {:ok, map}
  @type error :: {:error, map, http_status_code}

  @success_status_codes [200, 201]
  @server_error_status_code 500

  @success_status "success"

  @doc false
  @spec parse_response(HTTPoison.Response.t()) :: success | error
  def parse_response(%HTTPoison.Response{} = response) do
    case response do
      %{body: body, status_code: status} when status in @success_status_codes ->
        parse_body(body)

      %{body: body, status_code: status} ->
        {:error, Jason.decode!(body), status}
    end
  end

  @doc false
  @spec parse_error(HTTPoison.Error.t()) :: error
  def parse_error(%HTTPoison.Error{} = error) do
    {:error, "invalid response - " <> inspect(error), @server_error_status_code}
  end

  defp parse_body(%{"status" => @success_status, "data" => data} = body) do
    Jason.decode(data)
    |> case do
      {:ok, data} -> {:ok, data}
      {:error, _error} -> {:error, body, @server_error_status_code}
    end
  end

  defp parse_body(body) do
    {:error, body, @server_error_status_code}
  end
end
