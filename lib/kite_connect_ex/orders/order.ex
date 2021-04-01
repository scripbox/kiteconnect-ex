defmodule KiteConnectEx.Orders.Order do
  @moduledoc """
  Module to represent a order resource.

  - [Docs](https://kite.trade/docs/connect/v3/orders/#retrieving-orders)
  """

  @keys [
    order_id: nil,
    parent_order_id: nil,
    exchange_order_id: nil,
    placed_by: nil,
    variety: nil,
    status: nil,
    tradingsymbol: nil,
    exchange: nil,
    instrument_token: nil,
    transaction_type: nil,
    order_type: nil,
    product: nil,
    validity: nil,
    price: nil,
    quantity: nil,
    trigger_price: nil,
    average_price: nil,
    pending_quantity: nil,
    filled_quantity: nil,
    disclosed_quantity: nil,
    market_protection: nil,
    order_timestamp: nil,
    exchange_timestamp: nil,
    status_message: nil,
    tag: nil,
    meta: %{}
  ]

  @type t :: %__MODULE__{
          order_id: String.t(),
          parent_order_id: String.t(),
          exchange_order_id: String.t(),
          placed_by: String.t(),
          variety: String.t(),
          status: String.t(),
          tradingsymbol: String.t(),
          exchange: String.t(),
          instrument_token: Integer.t(),
          transaction_type: String.t(),
          order_type: String.t(),
          product: String.t(),
          validity: String.t(),
          price: Float.t(),
          quantity: Float.t(),
          trigger_price: Float.t(),
          average_price: Float.t(),
          pending_quantity: Float.t(),
          filled_quantity: Float.t(),
          disclosed_quantity: Float.t(),
          market_protection: Float.t(),
          order_timestamp: DateTime.t(),
          exchange_timestamp: DateTime.t(),
          status_message: String.t(),
          tag: String.t(),
          meta: %{}
        }

  @derive {Jason.Encoder, only: Keyword.keys(@keys)}
  defstruct @keys

  def new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      order_id: attributes["order_id"],
      parent_order_id: attributes["parent_order_id"],
      exchange_order_id: attributes["exchange_order_id"],
      placed_by: attributes["placed_by"],
      variety: attributes["variety"],
      status: attributes["status"],
      tradingsymbol: attributes["tradingsymbol"],
      exchange: attributes["exchange"],
      instrument_token: attributes["instrument_token"],
      transaction_type: attributes["transaction_type"],
      order_type: attributes["order_type"],
      product: attributes["product"],
      validity: attributes["validity"],
      price: attributes["price"],
      quantity: attributes["quantity"],
      trigger_price: attributes["trigger_price"],
      average_price: attributes["average_price"],
      pending_quantity: attributes["pending_quantity"],
      filled_quantity: attributes["filled_quantity"],
      disclosed_quantity: attributes["disclosed_quantity"],
      market_protection: attributes["market_protection"],
      order_timestamp: attributes["order_timestamp"],
      exchange_timestamp: attributes["exchange_timestamp"],
      status_message: attributes["status_message"],
      tag: attributes["tag"],
      meta: attributes["meta"]
    })
  end

  def new(_) do
    struct(__MODULE__, %{})
  end
end
