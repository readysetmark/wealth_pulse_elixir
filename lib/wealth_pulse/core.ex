defmodule WealthPulse.Core do

  defmodule Symbol do
    defstruct value: nil,
              quoted: false

    @type t :: %__MODULE__{
      value: String.t(),
      quoted: boolean()
    }
  end

end