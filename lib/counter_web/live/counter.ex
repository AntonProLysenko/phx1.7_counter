defmodule CounterWeb.Counter  do
  use CounterWeb, :live_view
  alias Counter.Count
  alias Phoenix.PubSub
  alias Counter.Presence

  @topic Count.topic
  @presence_topic "presence"
  @doc """
   CounterWeb.Endpoint.subscribe(@topic) for subscribing(connecting) to a chanel for multiClient data Share

   #Each client connected to the App subscribes to the @topic
   #so when the count is updated on any of the clients, all the other clients see the same value with no using of database.

   {:ok, assign(socket, :val, 0)} - Socket is out state which we'll be tracking in this process, val is a state variable which will be used in here
  """
 def mount(_params, _session, socket) do
  # CounterWeb.Endpoint.subscribe(@topic)
  PubSub.subscribe(Counter.PubSub, @topic)
  CounterWeb.Endpoint.subscribe(@presence_topic)

  Presence.track(self(), @presence_topic, socket.id, %{})

    initial_present =
      Presence.list(@presence_topic)
      |> map_size

    IO.inspect( Presence.list(@presence_topic), label: "initial_present")
    {:ok, assign(socket, val:  Count.current(), present: initial_present) }
 end
 def handle_event("inc", _unsigned_params, socket) do
  # new_state = update(socket, :val, fn val ->IO.inspect(socket.assigns, label: "Assigns in Socket State"); val + 1 end)#event listener, here we are increasing state by one
  # CounterWeb.Endpoint.broadcast_from(self(), @topic, "inc", new_state.assigns) # sends the message from self()(current procces) to the @topic with key "inc" and value newstate.assigns
  # {:noreply, new_state}
  {:noreply, assign(socket, :val, Count.incr())}
 end

 def handle_event("dec", _unsigned_params, socket) do
  # new_state = update(socket, :val, &(&1 - 1))# same as above event just diff math
  # CounterWeb.Endpoint.broadcast_from(self(), @topic, "dec", new_state.assigns)
  # {:noreply, new_state}
  {:noreply, assign(socket, :val, Count.decr())}
 end
 @doc """
 Handles Elix process messages where msg is received message and socket is Phoenix.Socket
 return means don't send this msg to the socket again(since inf loop will be fired)
 """
#  def handle_info(msg, socket) do
#   {:noreply, assign(socket, val: msg.payload.val)}
#  end

  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, val: count)}
  end

  def handle_info(
    %{event: "presence_diff", payload: %{joins: joins, leaves: leaves}},
    %{assigns: %{present: present}} = socket
    ) do
    new_present = present + map_size(joins) - map_size(leaves)


    {:noreply, assign(socket, :present, new_present)}
  end
# @doc """
# in assigns arg we have saved variables(in our case we created :val variable in mount function), assigns saved in socket.assigns
# ~H
# this is somilar to react <></> component means to treat code below as html,
# but also it will automaticaly fire mount/3 function and every update the mount function will be fired again
# """
#  def render(assigns) do
#    ~H"""
#    <div>
#     <h1 class = "text-4x1 font-bold text-center">The count is:<%= @val %></h1>
#     <p class = "text-center">
#       <.button phx-click="dec" class="bg-red-500 w-20 hover:bg-green-600">-</.button><!-- phx-click fires dec event which we are listening above-->
#       <.button phx-click = "inc" class="w-20 bg-blue-500 hover:bg-yellow-600">+</.button>
#     </p>
#    </div>
#    """
#  end

  @doc """
  replaced above code with live component ./counter_component.ex
  """
  def render(assigns) do
    ~H"""
      <.live_component module={CounterComponent} id="counter" val={@val}/>
      <.live_component module={PresenceComponent} id="presence" present={@present} />
    """
  end
end
