defmodule Mmlod.Utils do
  @moduledoc """
  Various utilities
  """

  def clean(binary) do
    binary
    |> :binary.bin_to_list()
    |> Enum.take_while(fn x -> x != 0 end)
  end

  def cut(binary, size, offset) do
    if size == 0 do
      <<>>
    else
      <<
        _::binary-size(offset),
        fragment::binary-size(size),
        _::binary
      >> = binary

      fragment
    end
  end

  def write_image(data, width, height, filename) do
    {:ok, file} = File.open(filename, [:write])
    IO.binwrite(file, "P6\n")
    IO.binwrite(file, "#{width} #{height} 255\n")

    Enum.reduce(0..(height - 1), data, fn _, rest ->
      rest =
        Enum.reduce(0..(width - 1), rest, fn _, rest ->
          <<
            red::unsigned-integer-3-little,
            green::unsigned-integer-3-little,
            blue::unsigned-integer-2-little,
            rest::binary
          >> = rest

          IO.binwrite(file, <<
            red * 32::unsigned-integer-8-little,
            green * 32::unsigned-integer-8-little,
            blue * 64::unsigned-integer-8-little
          >>)

          rest
        end)

      rest
    end)
  end
end
