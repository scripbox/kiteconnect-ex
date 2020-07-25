defmodule KiteConnectEx.Portfolio.Holding do
  @moduledoc """
  Module to represent a holding resource.

  - [Docs](https://kite.trade/docs/connect/v3/portfolio/#holdings)
  """

  @keys [
    trading_symbol: nil,
    exchange: nil,
    isin: nil,
    quantity: nil,
    t1_quantity: nil,
    average_price: nil,
    last_price: nil,
    pnl: nil,
    product: nil,
    collateral_quantity: nil,
    collateral_type: nil
  ]

  @type t :: %__MODULE__{
          trading_symbol: String.t(),
          exchange: String.t(),
          isin: String.t(),
          quantity: Integer.t(),
          t1_quantity: Integer.t(),
          average_price: Float.t(),
          last_price: Float.t(),
          pnl: Float.t(),
          product: String.t(),
          collateral_quantity: Integer.t(),
          collateral_type: String.t() | nil
        }

  defstruct @keys

  def new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      trading_symbol: attributes["tradingsymbol"],
      exchange: attributes["exchange"],
      isin: attributes["isin"],
      quantity: attributes["quantity"],
      t1_quantity: attributes["t1_quantity"],
      average_price: attributes["average_price"],
      last_price: attributes["last_price"],
      pnl: attributes["pnl"],
      product: attributes["product"],
      collateral_quantity: attributes["collateral_quantity"],
      collateral_type: attributes["collateral_type"]
    })
  end

  def new(_) do
    struct(__MODULE__, %{})
  end
end
