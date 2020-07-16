defmodule KiteConnectEx.Response do
  @type http_status_code :: number
  @type success :: {:ok, map}
  @type error :: {:error, map, http_status_code}

  @success_status_codes [200, 201]
  @server_error_status_code 500

  @spec parse_response(HTTPoison.Response.t()) :: success | error
  def parse_response(%HTTPoison.Response{} = response) do
    case response do
      %{body: body, status_code: status} when status in @success_status_codes ->
        {:ok, Jason.decode!(body)}

      %{body: body, status_code: status} ->
        {:error, Jason.decode!(body), status}
    end
  end

  @spec parse_error(HTTPoison.Error.t()) :: error
  def parse_error(%HTTPoison.Error{} = error) do
    {:error, "invalid response - " <> inspect(error), @server_error_status_code}
  end
end
