defmodule Mmlod do
  alias Mmlod.Lod

  def main(args) do
    [file, resource] = args

    {:ok, data} = File.read(file)

    item =
      data
      |> Lod.load()
      |> Lod.find(resource)

    {:ok, out} = File.open(resource, [:write])
    IO.binwrite(out, item.content)
  end
end
