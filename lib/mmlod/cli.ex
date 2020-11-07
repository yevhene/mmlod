defmodule Mmlod.CLI do
  @moduledoc """
  Command Line Interface
  """

  use ExCLI.DSL, mix_task: :mmlod, escript: true

  alias Mmlod.Command

  name("mmlod")
  description("Utility to process LOD files")

  command :info do
    aliases([:i])
    description("LOD file info")

    argument(:file)

    run context do
      Command.Info.run(context)
    end
  end

  command :list do
    aliases([:l])
    description("List LOD node index")

    argument(:file)

    run context do
      Command.List.run(context)
    end
  end

  command :extract do
    aliases([:e])
    description("Extract resource and save to file")

    argument(:type)
    argument(:resource)
    argument(:file)

    run context do
      Command.Extract.run(context)
    end
  end
end
