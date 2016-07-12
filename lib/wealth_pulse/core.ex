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
    alias WealthPulse.Core.Symbol

    defstruct quantity: Decimal.new(0),
              symbol: nil,
              symbol_location: nil,
              whitespace: false

    @type symbol_location :: :left | :right

    @type t :: %__MODULE__{
      quantity: Decimal.t(),
      symbol: Symbol.t(),
      symbol_location: symbol_location(),
      whitespace: boolean()
    }
  end

  defmodule Price do
    alias WealthPulse.Core.{Amount, Symbol}

    defstruct date: nil,
              symbol: nil,
              amount: nil
    
    @type t :: %__MODULE__{
      date: Date.t(),
      symbol: Symbol.t(),
      amount: Amount.t()
    }
  end

end