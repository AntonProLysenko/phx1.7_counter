defmodule CounterWeb.TestPage do
  use CounterWeb, :live_view

  def render(assigns) do

    ~H"""
    <div>TEST PAGE</div>
    """
  end

end
