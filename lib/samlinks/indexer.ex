defmodule Samlinks.Indexer do
  @moduledoc """
  Provides indexing and logging functions.

  ## Examples

  iex> Indexer.save!(%{"url": "http://foo/bar.com"})
  :ok

  iex> Indexer.save(%{"url": "http://foo/bar.com"})
  %Link{url: "http://foo/bar.com", slug: "7yAW89i"}

  """
  use GenServer
  @server __MODULE__

  alias Samlinks.Links

  # Client API

  @doc """
  Logs the link visit
  """
  def log_visit(link, ip, meta) do
    attrs = %{ip: ip, meta: meta}
    GenServer.cast(@server, {:log, {link, attrs}})
  end

  @doc """
  Saves the link in a non-blocking way, returns immediately
  """
  def save!(link_params) do
    GenServer.cast(@server, {:save_async, link_params})
  end

  @doc """
  Same as Indexer.save!/1, but returns the new record.
  """
  def save(link_params) do
    GenServer.call(@server, {:save, link_params})
  end

  # Server (callbacks)
  def start_link([]) do
    GenServer.start_link(__MODULE__, %{}, name: @server)
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:save, params}, _from, _state) do
    {:ok, link} = Links.create_link(params)
    {:reply, link}
  end

  @impl true
  def handle_cast({:save_async, params}, state) do
    Links.create_link(params)
    {:noreply, state}
  end

  @impl true
  def handle_cast({:log, {link, params}}, state) do
    Links.log_visit(link, params)
    {:noreply, state}
  end
end
