defmodule Timer do
  @moduledoc """
  Documentation for `Timer`.
  """

  def start do
    {:ok, pid} = GenServer.start(Countdown, 60 * 20)

    {:ok, _} =:timer.send_interval(:timer.seconds(1), pid, :tick)
  end
end
