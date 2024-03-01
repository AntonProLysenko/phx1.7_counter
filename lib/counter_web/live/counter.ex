defmodule CounterWeb.Counter  do
 use CounterWeb, :live_view

 def mount(_params, _session, socket) do
  {:ok, assign(socket, :val, 0)}#Socket is out state which we'll be tracking in this process, val is a state variable which will be used in here
 end

 def handle_event("inc", _unsigned_params, socket) do

  {:noreply, update(socket, :val, fn val ->IO.inspect(socket.assigns); val + 1 end)}#event listener, here we are increasing state by one
 end

 def handle_event("dec", _unsigned_params, socket) do
  {:noreply, update(socket, :val, &(&1 - 1))}# same as above event
 end



 def render(assigns) do# in assigns we have saved variables(in our case we created :val variable in mount function), assigns saved in socket.assigns
   ~H"""
    <!-- this is somilar to react <></> component means to treat code below as html,
     but also it will automaticaly fire mount/3 function and every update the mount function will be fired again -->
   <div>
    <h1 class = "text-4x1 font-bold text-center">The count is:<%= @val %></h1>

    <p class = "text-center">
      <.button phx-click="dec">-</.button><!-- phx-click fires dec event which we are listening above-->
      <.button phx-click = "inc">+</.button>
    </p>
   </div>
   """
 end
end
