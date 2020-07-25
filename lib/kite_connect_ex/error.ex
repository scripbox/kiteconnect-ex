defmodule KiteConnectEx.Error do
  @general_error "GeneralException"
  @token_error "TokenException"
  @permission_error "PermissionError"
  @user_error "UserException"
  @two_fa_error "TwoFAException"
  @order_error "OrderException"
  @input_error "InputException"
  @data_error "DataException"
  @network_error "NetworkException"

  defstruct [:error_type, :message, :code]

  def new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      error_type: attributes["error_type"],
      message: attributes["message"],
      code: error_code(attributes["error_type"])
    })
  end

  def new(_) do
    struct(__MODULE__, %{
      error_type: @general_error,
      message: "Server Error",
      code: error_code(@general_error)
    })
  end

  defp error_code(error_type) do
    error_type
    |> case do
      @general_error ->
        500

      @token_error ->
        403

      @permission_error ->
        403

      @user_error ->
        403

      @two_fa_error ->
        403

      @order_error ->
        400

      @input_error ->
        400

      @data_error ->
        504

      @network_error ->
        503

      _ ->
        500
    end
  end
end
