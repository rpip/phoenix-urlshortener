defmodule Samlinks.Scheduler do
  # every 2 hours
  @time_retry Application.get_env(:samlinks, :gc_time)
  alias Samlinks.Links

  use Task

  def start_link(_arg) do
    Task.start_link(&poll/0)
  end

  def poll() do
    receive do
    after
      @time_retry ->
        cleanup()
        poll()
    end
  end

  defp cleanup() do
    # clean up stale links
    IO.puts "Deleting stale links"
    Links.prune_links()
  end
end
