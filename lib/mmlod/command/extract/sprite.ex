defmodule Mmlod.Command.Extract.Sprite do
  @moduledoc """
  CLI command to extract sprite from LOD file
  """

  alias Mmlod.Lod
  alias Mmlod.Utils
  alias Mmlod.Resource.Sprite

  def run(%{file: file, resource: resource}) do
    {:ok, data} = File.read(file)

    node =
      data
      |> Lod.load()
      |> Lod.find(resource)

    sprite =
      node.content
      |> Sprite.load()

    Utils.write_image(
      sprite.data,
      sprite.width,
      sprite.height,
      "#{resource}.ppm"
    )
  end
end
