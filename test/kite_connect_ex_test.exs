defmodule KiteConnectExTest do
  use ExUnit.Case

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
