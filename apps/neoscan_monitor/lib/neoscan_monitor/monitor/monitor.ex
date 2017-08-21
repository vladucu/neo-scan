defmodule NeoscanMonitor.Server do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__ )
  end

  def init( :ok ) do
    {:ok, []}
  end

  def handle_info({:state_update, new_state}, _state) do
    {:noreply, new_state}
  end

  def handle_call(:nodes, _from, state) do
    {:reply, state.monitor.nodes, state}
  end

  def handle_call(:height, _from, state) do
    {:reply, state.monitor.height, state}
  end

  def handle_call(:transactions, _from, state) do
    {:reply, state.transactions, state}
  end

  def handle_call(:blocks, _from, state) do
    {:reply, state.blocks, state}
  end

  def handle_call(:assets, _from, state) do
    {:reply, state.assets, state}
  end

  def handle_call(:contracts, _from, state) do
    {:reply, state.contracts, state}
  end

  def handle_call(:data, _from, state) do
    {:reply, state.monitor.data, state}
  end
end
