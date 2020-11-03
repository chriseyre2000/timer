defmodule Countdown do
  use GenServer

  def init(state) do
    {:ok, state}
  end

  def handle_info(:tick, 0) do
    IO.puts "\rDone"
    {:stop, :timeout, 0}
  end

  def handle_info(:tick, state) do
    IO.write("\r#{state}\t")
    {:noreply, state - 1}
  end

end
