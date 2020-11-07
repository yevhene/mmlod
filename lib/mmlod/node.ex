defmodule Mmlod.Node do
  @moduledoc """
  Node in the LOD file. Can be folder or any resource
  """

  defstruct [
    :name,
    :f,
    :offset,
    :size,
    :length,
    :priority,
    children: nil,
    content: nil
  ]

  alias Mmlod.Node
  alias Mmlod.Utils

  def load(source) do
    {[node], _} = load(source, 1)
    node
  end

  defp load(source, count) do
    Enum.reduce(0..(count - 1), {[], source}, fn _, {list, rest} ->
      {node, rest} = load_header(rest)

      {node, rest} =
        if node.length > 0 do
          {children, rest} = load(rest, node.length)
          {%{node | children: children}, rest}
        else
          content = load_content(source, node.size, node.offset)
          {%{node | content: content}, rest}
        end

      {list ++ [node], rest}
    end)
  end

  defp load_header(source) do
    <<
      name::binary-size(15),
      f::integer-unsigned-8-little,
      offset::integer-unsigned-32-little,
      size::integer-unsigned-32-little,
      _::32,
      length::integer-unsigned-16-little,
      priority::integer-unsigned-16-little,
      rest::binary
    >> = source

    node = %Node{
      name: Utils.clean(name),
      f: f,
      offset: offset,
      size: size,
      length: length,
      priority: priority
    }

    {node, rest}
  end

  defp load_content(source, size, offset) do
    source
    |> Utils.cut(size, offset)
  end
end
