defmodule KiteConnectEx.User.FundAndMargin.AvailableSegment do
  @moduledoc """
  Module to represent an available segment resource

  - [Docs](https://kite.trade/docs/connect/v3/user/#funds-and-margins)
  """

  @keys [
    adhoc_margin: nil,
    cash: nil,
    collateral: nil,
    intraday_payin: nil
  ]

  @type t :: %__MODULE__{
          adhoc_margin: Float.t(),
          cash: Float.t(),
          collateral: Float.t(),
          intraday_payin: Float.t()
        }

  @derive {Jason.Encoder, only: Keyword.keys(@keys)}
  defstruct @keys

  def new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      adhoc_margin: attributes["adhoc_margin"],
      cash: attributes["cash"],
      collateral: attributes["collateral"],
      intraday_payin: attributes["intraday_payin"]
    })
  end

  def new(_) do
    struct(__MODULE__, %{})
  end
end
