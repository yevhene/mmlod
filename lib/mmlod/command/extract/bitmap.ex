defmodule Mmlod.Command.Extract.Bitmap do
  @moduledoc """
  CLI command to extract sprite from LOD file
  """

  alias Mmlod.Lod
  alias Mmlod.Utils
  alias Mmlod.Resource.Bitmap

  def run(%{file: file, resource: resource}) do
    {:ok, data} = File.read(file)

    node =
      data
      |> Lod.load()
      |> Lod.find(resource)

    bitmap =
      node.content
      |> Bitmap.load()

    Utils.write_image(
      bitmap.data,
      bitmap.width,
      bitmap.height,
      "#{resource}.ppm"
    )
  end
end
