defmodule Mmlod do
  alias Mmlod.Lod
  alias Mmlod.Sprite
  alias Mmlod.Utils

  def main(args) do
    [file, resource] = args

    {:ok, data} = File.read(file)

    item =
      data
      |> Lod.load()
      |> Lod.find(resource)

    IO.inspect item

    item.content
    |> Sprite.image_data()
    |> Utils.write_image(
      item.content.width,
      item.content.height,
      "#{resource}.ppm"
    )
  end
end
