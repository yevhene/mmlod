defmodule Mmlod.Resource.Bitmap do
  @moduledoc """
  Bitmap Resource
  """

  defstruct [
    :name,
    :detail_level,
    :size,
    :width,
    :height,
    :width2,
    :height2,
    :width3,
    :height3,
    :palette_id1,
    :palette_id2,
    :decompressed_size,
    :control,
    :data
  ]

  alias Mmlod.Resource.Bitmap
  alias Mmlod.Utils

  def load(source) do
    <<
      name::binary-size(16),
      detail_level::integer-unsigned-32-little,
      size::integer-unsigned-32-little,
      width::integer-unsigned-16-little,
      height::integer-unsigned-16-little,
      width2::integer-signed-16-little,
      height2::integer-signed-16-little,
      width3::integer-signed-16-little,
      height3::integer-signed-16-little,
      palette_id1::integer-unsigned-16-little,
      palette_id2::integer-unsigned-16-little,
      decompressed_size::integer-unsigned-32-little,
      control::integer-unsigned-32-little,
      data::binary
    >> = source

    %Bitmap{
      name: Utils.clean(name),
      detail_level: detail_level,
      size: size,
      width: width,
      height: height,
      width2: width2,
      height2: height2,
      width3: width3,
      height3: height3,
      palette_id1: palette_id1,
      palette_id2: palette_id2,
      decompressed_size: decompressed_size,
      control: control,
      data: data
    }
  end
end
