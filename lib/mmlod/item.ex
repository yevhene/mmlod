defmodule Mmlod.Item do
  defstruct [:name, :f, :offset, :size, :length, :priority, items: nil, content: nil]

  alias Mmlod.Item
  alias Mmlod.Utils

  def load(data, count \\ 1) do
    Enum.reduce(0..(count - 1), {[], data}, fn _, {list, rest} ->
      {item, rest} = load_header(rest)

      {item, rest} =
        if item.length > 0 do
          {items, rest} = load(rest, item.length)
          {%{item | items: items}, rest}
        else
          content = load_content(data, item.size, item.offset)
          {%{item | content: content}, rest}
        end

      {list ++ [item], rest}
    end)
  end

  defp load_header(data) do
    <<
      name::binary-size(15),
      f::8-little,
      offset::32-little,
      size::32-little,
      _::32-little,
      length::16-little,
      priority::16-little,
      rest::binary
    >> = data

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

  defp load_content(data, size, offset) do
    <<
      _::binary-size(offset),
      content::binary-size(size),
      _::binary
    >> = data

    content
  end
end
