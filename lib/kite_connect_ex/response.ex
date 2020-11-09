defmodule KiteConnectEx.Response do
  @type success :: {:ok, map}
  @type error :: {:error, %KiteConnectEx.Error{}}

  @success_status_codes [200, 201]

  @success_status "success"
  @error_status "error"

  @doc false
  @spec parse_csv_response(HTTPoison.Response.t()) :: success | error
  def parse_csv_response(%HTTPoison.Response{} = response) do
    case response do
      %{body: body, status_code: status} when status in @success_status_codes ->
        {:ok, body}

      %{body: body, status_code: _status} ->
        {:error, KiteConnectEx.Error.new(body)}
    end
  end

  @doc false
  @spec parse_response(HTTPoison.Response.t()) :: success | error
  def parse_response(%HTTPoison.Response{} = response) do
    case response do
      %{body: body, status_code: status} when status in @success_status_codes ->
        {:ok, body}

      %{body: body, status_code: _status} ->
        error =
          body
          |> Jason.decode!()
          |> parse_body()

        {:error, error}
    end
  end

  @doc false
  @spec parse_error(HTTPoison.Error.t()) :: error
  def parse_error(%HTTPoison.Error{} = error) do
    error =
      %{"message" => "invalid response - " <> inspect(error)}
      |> KiteConnectEx.Error.new()

    {:error, error}
  end

  defp parse_body(%{"status" => @success_status, "data" => data} = _body) do
    data
  end

  defp parse_body(
         %{"status" => @error_status, "message" => message, "error_type" => error_type} = _body
       ) do
    %{"error_type" => error_type, "message" => message}
    |> KiteConnectEx.Error.new()
  end

  defp parse_body(body) do
    KiteConnectEx.Error.new(body)
  end
end
