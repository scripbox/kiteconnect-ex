defmodule KiteConnectEx.User.FundAndMargin do
  alias KiteConnectEx.User.FundAndMargin.AvailableSegment
  alias KiteConnectEx.User.FundAndMargin.UtilisedSegment

  @moduledoc """
  Module to represent an fund and margin resource

  - [Docs](https://kite.trade/docs/connect/v3/user/#funds-and-margins)
  """

  @keys [
    enabled: false,
    net: nil,
    available: nil,
    utilised: nil
  ]

  @type t :: %__MODULE__{
          enabled: Bool.t(),
          net: Float.t(),
          available: %AvailableSegment{},
          utilised: %UtilisedSegment{}
        }

  @derive {Jason.Encoder, only: Keyword.keys(@keys)}
  defstruct @keys

  def new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      enabled: attributes["enabled"],
      net: attributes["net"],
      available: AvailableSegment.new(attributes["available"]),
      utilised: UtilisedSegment.new(attributes["utilised"])
    })
  end

  def new(_) do
    struct(__MODULE__, %{})
  end
end
