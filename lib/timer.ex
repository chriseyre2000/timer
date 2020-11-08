defmodule Timer do
  @moduledoc """
  Triggers a countdown timer.
  """

  @doc """
  Starts a countdown timer. The parameter is seconds.
  Will default to 20 mins
  """
  @spec start(seconds::non_neg_integer()) :: any()
  def start(seconds \\ 60 * 20) do
    Countdown.start( seconds )
  end
end
