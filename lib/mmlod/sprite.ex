defmodule Mmlod.Sprite do
  defstruct [
    :name,
    :size,
    :width,
    :height,
    :palette_id,
    :texture_pitch,
    :decompressed_size,
    :data
  ]

  alias Mmlod.Sprite
  alias Mmlod.Utils

  def load(source) do
    <<
      name::binary-size(12),
      size::integer-unsigned-32-little,
      width::integer-unsigned-16-little,
      height::integer-unsigned-16-little,
      palette_id::integer-unsigned-16-little,
      _::16,
      texture_pitch::integer-unsigned-16-little,
      _::16,
      decompressed_size::integer-unsigned-32-little,
      rest::binary
    >> = source

    %Sprite{
      name: Utils.clean(name),
      size: size,
      width: width,
      height: height,
      palette_id: palette_id,
      texture_pitch: texture_pitch,
      decompressed_size: decompressed_size,
      data: rest
    }
  end

  def image_data(%Sprite{height: height, width: width, data: data}) do
    {lines, rest} = load_lines(data, height)

    uncompressed = :zlib.uncompress(rest)

    Enum.reduce(lines, <<>>, fn line, result ->
      %{start: start, finish: finish, offset: offset} = line

      if start >= 0 do
        left_padding_size = start
        size = finish - start
        right_padding_size = width - left_padding_size - size
        left_padding_size_bits = left_padding_size * 8
        right_padding_size_bits = right_padding_size * 8

        content = Utils.cut(uncompressed, size, offset)

        result <>
          <<0::size(left_padding_size_bits)>> <>
          <<content::binary-size(size)>> <>
          <<0::size(right_padding_size_bits)>>
      else
        width_bits = width * 8

        result <>
          <<0::size(width_bits)>>
      end
    end)
  end

  defp load_lines(source, count) do
    Enum.reduce(0..(count - 1), {[], source}, fn _, {list, rest} ->
      <<
        start::integer-signed-16-little,
        finish::integer-signed-16-little,
        offset::integer-unsigned-32-little,
        rest::binary
      >> = rest

      line = %{
        start: start,
        finish: finish,
        offset: offset
      }

      {list ++ [line], rest}
    end)
  end
end
