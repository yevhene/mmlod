defmodule Mmlod.Lod do
  defstruct [:signature, :version, :description, :data, :root]

  alias Mmlod.Lod
  alias Mmlod.Item
  alias Mmlod.Utils

  def load(data) do
    <<
      signature::binary-size(4),
      version::binary-size(80),
      description::binary-size(80),
      100::32-little,
      0::32-little,
      1::32-little,
      _unknown::binary-size(80),
      rest::binary
    >> = data

    {root, _} = Item.load(rest)

    lod = %Lod{
      signature: Utils.clean(signature),
      version: Utils.clean(version),
      description: Utils.clean(description),
      data: data,
      root: root
    }

    lod
  end

  def find(%Lod{root: root}, name) do
    Enum.find(root.items, fn item ->
      String.downcase(List.to_string(item.name)) == String.downcase(name)
    end)
  end

  def extract(%Lod{data: data} = lod, name) do
    %Item{offset: item_offset, size: size} = Lod.find(lod, name)
    offset = lod.root.offset + item_offset

    <<
      _::binary-size(offset),
      content::binary-size(size),
      _::binary
    >> = data

    content
  end
end

defimpl String.Chars, for: Mmlod.Lod do
  alias Mmlod.Lod

  def to_string(%Lod{} = lod) do
    lod.root.items
    |> Enum.map(fn item -> List.to_string(item.name) end)
    |> Enum.join("\n")
  end
end