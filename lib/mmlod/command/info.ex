defmodule Mmlod.Command.Info do
  @moduledoc """
  CLI command to show basic LOD info
  """

  alias Mmlod.Lod

  def run(%{file: file}) do
    {:ok, data} = File.read(file)

    data
    |> Lod.load()
    |> process_lod()
  end

  defp process_lod(
         %Lod{
           signature: signature,
           version: version,
           description: description
         } = lod
       ) do
    IO.puts("LOD File")
    IO.puts("Signature: #{signature}")
    IO.puts("Version: #{version}")
    IO.puts("Description: #{description}")
    lod
  end
end
