defmodule Mmlod.Item do
  defstruct [
    :name,
    :f,
    :offset,
    :size,
    :length,
    :priority,
    items: nil,
    content: nil
  ]

  alias Mmlod.Sprite
  alias Mmlod.Item
  alias Mmlod.Utils

  def load(source) do
    {[item], _} = load(source, 1)
    item
  end

  def load(source, count) do
    Enum.reduce(0..(count - 1), {[], source}, fn _, {list, rest} ->
      {item, rest} = load_header(rest)

      {item, rest} =
        if item.length > 0 do
          {items, rest} = load(rest, item.length)
          {%{item | items: items}, rest}
        else
          content = load_content(source, item.size, item.offset)
          {%{item | content: content}, rest}
        end

      {list ++ [item], rest}
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

    item = %Item{
      name: Utils.clean(name),
      f: f,
      offset: offset,
      size: size,
      length: length,
      priority: priority
    }

    {item, rest}
  end

  def load_content(source, size, offset) do
    source
    |> Utils.cut(size, offset)
    |> Sprite.load()
  end
end
