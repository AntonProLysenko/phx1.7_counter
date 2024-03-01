defmodule Counter.Count do
  @moduledoc """
  The GenServer runs in its own process. Other parts of the application invoke the API in their own process,
  these calls are forwarded to the handle_call functions in the GenServer process where they are processed serially.

  We have also moved the PubSub publication here as well.

  We are also going to need to tell the Application that it now has some business logic;
  we do this in the start/2 function in the lib/counter/application.ex file.
  """
  use GenServer
  alias Phoenix.PubSub
  @name :count_server

  @start_value 0

  def topic do
    "count"
  end

  def start_link(_opts)do
    GenServer.start_link(__MODULE__, @start_value, name: @name)
  end

  def incr()do
    GenServer.call(@name, :incr)
  end

  def decr()do
    GenServer.call(@name, :decr)
  end

  def current() do
    GenServer.call(@name, :current)
  end


  #Implementation
  def init(start_count) do
    {:ok, start_count}
  end

  def handle_call(:current, _from, count) do
    {:reply, count, count}
 end

  def handle_call(:incr, _from, count) do
    new_count = count+1
    PubSub.broadcast(Counter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end

  def handle_call(:decr, _from, count) do
    new_count = count-1
    PubSub.broadcast(Counter.PubSub, topic(), {:count, new_count})
    {:reply, new_count, new_count}
  end


end
