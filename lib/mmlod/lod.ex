defmodule Mmlod.Lod do
  @moduledoc """
  Module for processing LOD files
  """

  defstruct [:signature, :version, :description, :root]

  alias Mmlod.Lod
  alias Mmlod.Node
  alias Mmlod.Utils

  def load(source) do
    <<
      signature::binary-size(4),
      version::binary-size(80),
      description::binary-size(80),
      100::integer-unsigned-32-little,
      0::integer-unsigned-32-little,
      1::integer-unsigned-32-little,
      _::binary-size(80),
      rest::binary
    >> = source

    root = Node.load(rest)

    lod = %Lod{
      signature: Utils.clean(signature),
      version: Utils.clean(version),
      description: Utils.clean(description),
      root: root
    }

    lod
  end

  def find(%Lod{root: root}, name) do
    Enum.find(root.children, fn node ->
      String.downcase(List.to_string(node.name)) == String.downcase(name)
    end)
  end
end

defimpl String.Chars, for: Mmlod.Lod do
  alias Mmlod.Lod

  def to_string(%Lod{} = lod) do
    lod.root.children
    |> Enum.map(fn node -> List.to_string(node.name) end)
    |> Enum.join("\n")
  end
end
