defmodule WealthPulse.Core do

  defmodule Symbol do
    defstruct value: nil,
              quoted: false

    @type t :: %__MODULE__{
      value: String.t(),
      quoted: boolean()
    }
  end

  defmodule Amount do
    defstruct quantity: Decimal.new(0),
              symbol: nil,
              symbol_location: nil,
              whitespace: false

    @type symbol_location :: :left | :right

    @type t :: %__MODULE__{
      quantity: Decimal.t(),
      symbol: WealthPulse.Core.Symbol.t(),
      symbol_location: symbol_location(),
      whitespace: boolean()
    }
  end

end