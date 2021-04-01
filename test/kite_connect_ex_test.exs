defmodule KiteConnectExTest do
  use ExUnit.Case
  alias KiteConnectEx.SampleResponse.Orders.{Order}

  setup do
    bypass = Bypass.open()
    Application.put_env(:kite_connect_ex, :base_url, "http://localhost:#{bypass.port}")

    on_exit(fn ->
      Application.put_env(:kite_connect_ex, :base_url, nil)
    end)

    {:ok, bypass: bypass}
  end

  describe "api_key/0" do
    test "returns configure api_key" do
      assert KiteConnectEx.api_key() == "api-key"
    end
  end

  describe "api_secret/0" do
    test "returns configure api_secret" do
      assert KiteConnectEx.api_secret() == "api-secret"
    end
  end

  describe "request_options/0" do
    test "returns configure request_options" do
      assert KiteConnectEx.request_options() == [{:timeout, 5000}, {:recv_timeout, 5000}]
    end
  end

  describe "get_login_url/1" do
    test "returns login_url with params" do
      params = %{"foo" => "bar"}

      assert KiteConnectEx.get_login_url(params) ==
               {:ok,
                "https://kite.zerodha.com/connect/login?api_key=api-key&redirect_params=foo%3Dbar&v=3"}
    end
  end

  describe "create_session/1" do
    test "returns user details with valid request_token", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/session/token", fn conn ->
        Plug.Conn.resp(conn, 201, create_session_response())
      end)

      assert KiteConnectEx.create_session("request-token") ==
               {:ok,
                %KiteConnectEx.User{
                  access_token: "yyyyyy",
                  api_key: "xxxxxx",
                  avatar_url: nil,
                  broker: "ZERODHA",
                  email: "kite@kite.trade",
                  exchanges: ["MCX", "BSE", "NSE", "BFO", "NFO", "CDS"],
                  login_time: "2018-01-01 16:15:14",
                  meta: nil,
                  order_types: ["LIMIT", "MARKET", "SL", "SL-M"],
                  original_json: %{
                    "access_token" => "yyyyyy",
                    "api_key" => "xxxxxx",
                    "avatar_url" => nil,
                    "broker" => "ZERODHA",
                    "email" => "kite@kite.trade",
                    "exchanges" => ["MCX", "BSE", "NSE", "BFO", "NFO", "CDS"],
                    "login_time" => "2018-01-01 16:15:14",
                    "order_types" => ["LIMIT", "MARKET", "SL", "SL-M"],
                    "products" => ["BO", "CNC", "CO", "MIS", "NRML"],
                    "public_token" => "zzzzzz",
                    "refresh_token" => nil,
                    "user_id" => "XX000",
                    "user_name" => "Kite Connect",
                    "user_shortname" => "Kite",
                    "user_type" => "investor"
                  },
                  products: ["BO", "CNC", "CO", "MIS", "NRML"],
                  public_token: "zzzzzz",
                  refresh_token: nil,
                  silo: nil,
                  user_id: "XX000",
                  user_name: "Kite Connect",
                  user_shortname: "Kite",
                  user_type: "investor"
                }}
    end

    test "returns error if API request fails", %{bypass: bypass} do
      Bypass.expect_once(bypass, "POST", "/session/token", fn conn ->
        Plug.Conn.resp(
          conn,
          400,
          ~s<{"status": "error", "error_type": "GeneralException", "message": "Invalid attributes"}>
        )
      end)

      assert KiteConnectEx.create_session("request-token") ==
               {:error,
                %KiteConnectEx.Error{
                  code: 500,
                  error_type: "GeneralException",
                  message: "Invalid attributes"
                }}
    end
  end

  defp create_session_response do
    """
    {
      "status": "success",
      "data": {
        "user_id": "XX000",
        "user_name": "Kite Connect",
        "user_shortname": "Kite",
        "email": "kite@kite.trade",
        "user_type": "investor",
        "broker": "ZERODHA",
        "exchanges": [
          "MCX",
          "BSE",
          "NSE",
          "BFO",
          "NFO",
          "CDS"
        ],
        "products": [
          "BO",
          "CNC",
          "CO",
          "MIS",
          "NRML"
        ],
        "order_types": [
          "LIMIT",
          "MARKET",
          "SL",
          "SL-M"
        ],
        "api_key": "xxxxxx",
        "access_token": "yyyyyy",
        "public_token": "zzzzzz",
        "refresh_token": null,
        "login_time": "2018-01-01 16:15:14",
        "avatar_url": null
      }
    }
    """
  end

  describe "funds_and_margins/2" do
    test "returns funds and margins for equity with valid response", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/user/margins/equity", fn conn ->
        Plug.Conn.resp(conn, 201, funds_and_margins_response())
      end)

      assert KiteConnectEx.funds_and_margins("access-token", "equity") ==
               {:ok,
                %KiteConnectEx.User.FundAndMargin{
                  available: %KiteConnectEx.User.FundAndMargin.AvailableSegment{
                    adhoc_margin: 0,
                    cash: 622.32,
                    collateral: 0,
                    intraday_payin: 0
                  },
                  enabled: true,
                  net: 622.32,
                  utilised: %KiteConnectEx.User.FundAndMargin.UtilisedSegment{
                    debits: 0,
                    exposure: 0,
                    holding_sales: 0,
                    m2m_realised: 0,
                    m2m_unrealised: 0,
                    option_premium: 0,
                    payout: 0,
                    span: 0,
                    turnover: 0
                  },
                  margin_data: %{
                    "available" => %{
                      "adhoc_margin" => 0,
                      "cash" => 622.32,
                      "collateral" => 0,
                      "intraday_payin" => 0,
                      "live_balance" => 622.32,
                      "opening_balance" => 622.32
                    },
                    "enabled" => true,
                    "net" => 622.32,
                    "utilised" => %{
                      "debits" => 0,
                      "delivery" => 0,
                      "exposure" => 0,
                      "holding_sales" => 0,
                      "liquid_collateral" => 0,
                      "m2m_realised" => 0,
                      "m2m_unrealised" => 0,
                      "option_premium" => 0,
                      "payout" => 0,
                      "span" => 0,
                      "stock_collateral" => 0,
                      "turnover" => 0
                    }
                  }
                }}
    end

    test "returns error if API request fails", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/user/margins/equity", fn conn ->
        Plug.Conn.resp(
          conn,
          403,
          ~s<{"status": "error", "error_type": "TokenException", "message": "Invalid access_token"}>
        )
      end)

      assert KiteConnectEx.funds_and_margins("access-token", "equity") ==
               {:error,
                %KiteConnectEx.Error{
                  code: 403,
                  error_type: "TokenException",
                  message: "Invalid access_token"
                }}
    end

    defp funds_and_margins_response do
      """
      {
        "status": "success",
        "data": {
          "available": {
            "adhoc_margin": 0,
            "cash": 622.32,
            "collateral": 0,
            "intraday_payin": 0,
            "live_balance": 622.32,
            "opening_balance": 622.32
          },
          "enabled": true,
          "net": 622.32,
          "utilised": {
            "debits": 0,
            "delivery": 0,
            "exposure": 0,
            "holding_sales": 0,
            "liquid_collateral": 0,
            "m2m_realised": 0,
            "m2m_unrealised": 0,
            "option_premium": 0,
            "payout": 0,
            "span": 0,
            "stock_collateral": 0,
            "turnover": 0
          }
        }
      }
      """
    end
  end

  describe "orders/1" do
    test "returns orders with valid response", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/orders", fn conn ->
        Plug.Conn.resp(conn, 201, all_orders())
      end)

      assert KiteConnectEx.orders("access-token") ==
      {:ok,
      [
        %{
          "average_price" => 0,
          "cancelled_quantity" => 0,
          "disclosed_quantity" => 0,
          "exchange" => "NSE",
          "exchange_order_id" => "1300000009032605",
          "exchange_timestamp" => "2021-04-01 13:31:36",
          "exchange_update_timestamp" => "2021-04-01 13:31:36",
          "filled_quantity" => 0,
          "guid" => "3106Xndfsskwjufvb",
          "instrument_token" => 1522689,
          "market_protection" => 0,
          "meta" => %{},
          "order_id" => "210401003340053",
          "order_timestamp" => "2021-04-01 13:31:35",
          "order_type" => "LIMIT",
          "parent_order_id" => nil,
          "pending_quantity" => 1,
          "placed_by" => "XG0030",
          "price" => 8.55,
          "product" => "MIS",
          "quantity" => 1,
          "status" => "OPEN",
          "status_message" => nil,
          "status_message_raw" => nil,
          "tag" => nil,
          "tradingsymbol" => "SOUTHBANK",
          "transaction_type" => "BUY",
          "trigger_price" => 0,
          "validity" => "DAY",
          "variety" => "regular"
        }
      ]}
    end

    test "returns error if API request fails", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/orders", fn conn ->
        Plug.Conn.resp(
          conn,
          403,
          ~s<{"status": "error", "error_type": "TokenException", "message": "Invalid access_token"}>
        )
      end)

      assert KiteConnectEx.orders("access-token") ==
               {:error,
                %KiteConnectEx.Error{
                  code: 403,
                  error_type: "TokenException",
                  message: "Invalid access_token"
                }}
    end

    def all_orders() do
      """
      {
        "data": [
          {
            "average_price": 0,
            "cancelled_quantity": 0,
            "disclosed_quantity": 0,
            "exchange": "NSE",
            "exchange_order_id": "1300000009032605",
            "exchange_timestamp": "2021-04-01 13:31:36",
            "exchange_update_timestamp": "2021-04-01 13:31:36",
            "filled_quantity": 0,
            "guid": "3106Xndfsskwjufvb",
            "instrument_token": 1522689,
            "market_protection": 0,
            "meta": {},
            "order_id": "210401003340053",
            "order_timestamp": "2021-04-01 13:31:35",
            "order_type": "LIMIT",
            "parent_order_id": null,
            "pending_quantity": 1,
            "placed_by": "XG0030",
            "price": 8.55,
            "product": "MIS",
            "quantity": 1,
            "status": "OPEN",
            "status_message": null,
            "status_message_raw": null,
            "tag": null,
            "tradingsymbol": "SOUTHBANK",
            "transaction_type": "BUY",
            "trigger_price": 0,
            "validity": "DAY",
            "variety": "regular"
          }
        ],
        "status": "success"
      }
      """
    end
  end

  describe "holdings/1" do
    test "returns portfolio holdings with valid access_token", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/portfolio/holdings", fn conn ->
        Plug.Conn.resp(conn, 201, holdings_response())
      end)

      assert KiteConnectEx.holdings("access-token") ==
               {:ok,
                [
                  %KiteConnectEx.Portfolio.Holding{
                    average_price: 94.75,
                    collateral_quantity: 0,
                    collateral_type: nil,
                    exchange: "BSE",
                    isin: "INE516F01016",
                    last_price: 93.75,
                    pnl: -100.0,
                    product: "CNC",
                    quantity: 1,
                    t1_quantity: 1,
                    trading_symbol: "ABHICAP"
                  },
                  %KiteConnectEx.Portfolio.Holding{
                    average_price: 475.0,
                    collateral_quantity: 0,
                    collateral_type: nil,
                    exchange: "NSE",
                    isin: "INE238A01034",
                    last_price: 432.55,
                    pnl: -42.5,
                    product: "CNC",
                    quantity: 1,
                    t1_quantity: 0,
                    trading_symbol: "AXISBANK"
                  }
                ]}
    end

    test "returns error if API request fails", %{bypass: bypass} do
      Bypass.expect_once(bypass, "GET", "/portfolio/holdings", fn conn ->
        Plug.Conn.resp(
          conn,
          403,
          ~s<{"status": "error", "error_type": "TokenException", "message": "Invalid access_token"}>
        )
      end)

      assert KiteConnectEx.holdings("access-token") ==
               {:error,
                %KiteConnectEx.Error{
                  code: 403,
                  error_type: "TokenException",
                  message: "Invalid access_token"
                }}
    end

    defp holdings_response do
      """
      {
        "status": "success",
        "data": [
          {
            "tradingsymbol": "ABHICAP",
            "exchange": "BSE",
            "isin": "INE516F01016",
            "quantity": 1,
            "t1_quantity": 1,
            "average_price": 94.75,
            "last_price": 93.75,
            "pnl": -100.0,
            "product": "CNC",
            "collateral_quantity": 0,
            "collateral_type": null
          },
          {
            "tradingsymbol": "AXISBANK",
            "exchange": "NSE",
            "isin": "INE238A01034",
            "quantity": 1,
            "t1_quantity": 0,
            "average_price": 475.0,
            "last_price": 432.55,
            "pnl": -42.50,
            "product": "CNC",
            "collateral_quantity": 0,
            "collateral_type": null
          }
        ]
      }
      """
    end
  end
end
