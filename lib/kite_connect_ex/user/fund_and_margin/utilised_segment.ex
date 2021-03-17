defmodule KiteConnectEx.User.FundAndMargin.UtilisedSegment do
  @moduledoc """
  Module to represent an available segment resource

  - [Docs](https://kite.trade/docs/connect/v3/user/#funds-and-margins)
  """

  @keys [
    debits: nil,
    exposure: nil,
    m2m_realised: nil,
    m2m_unrealised: nil,
    option_premium: nil,
    payout: nil,
    span: nil,
    holding_sales: nil,
    turnover: nil
  ]

  @type t :: %__MODULE__{
          debits: Float.t(),
          exposure: Float.t(),
          m2m_realised: Float.t(),
          m2m_unrealised: Float.t(),
          option_premium: Float.t(),
          payout: Float.t(),
          span: Float.t(),
          holding_sales: Float.t(),
          turnover: Float.t()
        }

  @derive {Jason.Encoder, only: Keyword.keys(@keys)}
  defstruct @keys

  def new(attributes) when is_map(attributes) do
    struct(__MODULE__, %{
      debits: attributes["debits"],
      exposure: attributes["exposure"],
      m2m_realised: attributes["m2m_realised"],
      m2m_unrealised: attributes["m2m_unrealised"],
      option_premium: attributes["option_premium"],
      payout: attributes["payout"],
      span: attributes["span"],
      holding_sales: attributes["holding_sales"],
      turnover: attributes["turnover"]
    })
  end

  def new(_) do
    struct(__MODULE__, %{})
  end
end
