defmodule Mmlod.Item do
  defstruct [:name, :f, :offset, :size, :length, :priority, :items]

  alias Mmlod.Item
  alias Mmlod.Utils

  def load_all(data, 0), do: {nil, data}

  def load_all(data, count) do
    Enum.reduce(0..(count - 1), {[], data}, fn _, {list, data} ->
      {item, rest} = load(data)
      {list ++ [item], rest}
    end)
  end

  def load(data) do
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

    {items, rest} = Item.load_all(rest, length)

    item = %Item{
      name: Utils.clean(name),
      f: f,
      offset: offset,
      size: size,
      length: length,
      priority: priority,
      items: items
    }

    {item, rest}
  end
end
