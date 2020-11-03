defmodule Mmlod do
  alias Mmlod.Lod

  def main(args) do
    [file, resource] = args

    {:ok, data} = File.read(file)

    content =
      data
      |> Lod.load()
      |> Lod.extract(resource)

    {:ok, out} = File.open(resource, [:write])
    IO.binwrite(out, content)
  end
end
