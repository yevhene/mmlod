defmodule Mmlod.Utils do
  def clean(binary) do
    binary
    |> :binary.bin_to_list()
    |> Enum.take_while(fn x -> x != 0 end)
  end
end
