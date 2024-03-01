defmodule CounterWeb.PageControllerTest do
  use CounterWeb.ConnCase
  import Phoenix.LiveViewTest

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Counter: 0"
  end

  test "Increment", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :inc) =~ "Counter: 1"
  end


  test "Decrement", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    assert render_click(view, :dec) =~ "Counter: -1"
  end

  test "handle_info/2 brodcast msg", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")
    {:ok, view2, _html} = live(conn, "/")

    assert render_click(view, :inc) =~ "Counter: 1"
    assert render_click(view2, :inc) =~ "Counter: 2"
  end
end
