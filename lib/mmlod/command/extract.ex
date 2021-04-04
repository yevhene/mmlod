defmodule Mmlod.Command.Extract do
  @moduledoc """
  Generic CLI command to extract resource from LOD file
  """

  @types ["bitmap", "sprite"]

  def run(%{type: "bitmap"} = context) do
    Mmlod.Command.Extract.Bitmap.run(context)
  end

  def run(%{type: "sprite"} = context) do
    Mmlod.Command.Extract.Sprite.run(context)
  end

  def run(%{type: type}) do
    IO.puts("Error: Unknown type: #{type}")
    IO.puts("Know types are: #{Enum.join(@types, ", ")}")
  end
end
