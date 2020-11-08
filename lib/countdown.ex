defmodule Countdown do
  use GenServer

  @type t :: %Countdown{
    remaining: non_neg_integer(),
    timeref: any()
  }
  defstruct ~w[remaining timeref]a

  @spec init(Countdown.t()) :: {:ok, Countdown.t()}
  def init(%Countdown{} = state) do
    {:ok, state}
  end

  def handle_info(:tick, %Countdown{remaining: 0, timeref: timeref} = state) do
    {:ok, :cancel} = :timer.cancel(timeref)

    IO.puts "\rDone"
    {:stop, :timeout, state}
  end

  def handle_info(:tick, %Countdown{remaining: seconds} = state) do
    IO.write("\r#{seconds}\t")
    {:noreply, %{state | remaining: seconds - 1 }}
  end

  def handle_cast(:stop, %Countdown{timeref: timeref} = state) do
    {:ok, :cancel} = :timer.cancel(timeref)
    IO.puts "\rStopped"
    {:stop, :stopped, state}
  end

  def handle_cast({:timeref, timeref}, %Countdown{} = state) do
    {:noreply, %Countdown{ state | timeref: timeref} }
  end

  def terminate(reason, _state) do
    IO.puts "Terminating with #{reason}"
    :normal
  end

  # External API

  @doc """
  Starts the countdown timer
  """
  @spec start(seconds :: non_neg_integer()) :: :ok
  def start(seconds) do
    state = %Countdown{remaining: seconds}
    {:ok, pid} = GenServer.start(Countdown, state, name: __MODULE__ )
    {:ok, timeref} = :timer.send_interval(:timer.seconds(1), pid, :tick)
    GenServer.cast(pid, {:timeref, timeref})
  end

  @doc """
  Starts the countdown timer early
  """
  @spec stop :: :ok
  def stop() do
    GenServer.cast(__MODULE__, :stop)
  end
end
