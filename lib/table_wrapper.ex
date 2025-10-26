defmodule ExMarcel.TableWrapper do
  use GenServer

  def init(arg) do
    :ets.new(:wrapper, [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ])

    setup()

    {:ok, arg}
  end

  def start_link(arg) do
    GenServer.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def setup do
    ExMarcel.TableWrapper.put("extensions", ExMarcel.Tables.extensions())
    ExMarcel.TableWrapper.put("type_exts", ExMarcel.Tables.type_exts())
    ExMarcel.TableWrapper.put("type_parents", ExMarcel.Tables.type_parents())
    ExMarcel.TableWrapper.put("magic", ExMarcel.Tables.magic())
    ExMarcel.Definitions.run_definitions()
  end

  def get(key) do
    case :ets.lookup(:wrapper, key) do
      [] ->
        nil

      [{_key, value}] ->
        value
    end
  end

  def put(key, value) do
    :ets.insert(:wrapper, {key, value})
  end

  def extensions, do: get("extensions")
  def type_exts, do: get("type_exts")
  def type_parents, do: get("type_parents")
  def magic, do: get("magic")
end
