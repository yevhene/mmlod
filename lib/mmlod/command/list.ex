defmodule Mmlod.Command.List do
  @moduledoc """
  CLI command to show node list contained in LOD file
  """

  alias Mmlod.Lod
  alias Mmlod.Node

  def run(%{file: file}) do
    {:ok, data} = File.read(file)

    data
    |> Lod.load()
    |> process_lod()
  end

  defp process_lod(%Lod{root: root} = lod) do
    process_node(root, 1)
    lod
  end

  defp process_node(%Node{name: name, children: children}, level) do
    IO.puts(String.duplicate("-", level) <> " " <> List.to_string(name))
    process_nodes(children, level + 1)
  end

  defp process_nodes(nil, _), do: nil

  defp process_nodes(children, level) do
    children |> Enum.each(fn node -> process_node(node, level) end)
  end
end
