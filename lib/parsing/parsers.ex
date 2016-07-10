defmodule WealthPulse.Parsing.Parsers do
  import Combine.Parsers.Base
  import Combine.Parsers.Text
  import Combine.Helpers

  # Whitespace Parsers

  @doc """
  Expects and parses mandatory whitespace (spaces or tabs). Returns :whitespace.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse(" ", mandatory_whitespace)
      [:whitespace]
      iex> Combine.parse("\t", mandatory_whitespace)
      [:whitespace]
      iex> Combine.parse(" \t", mandatory_whitespace)
      [:whitespace]
  """
  def mandatory_whitespace, do: many1(either(space, tab)) |> map(fn _ -> :whitespace end)

  @doc """
  Expects and parses optional whitespace. Returns :whitespace if whitespace was found, otherwise
  returns :no_whitespace. Whitespace here must be a space or tab.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse(" ", optional_whitespace)
      [:whitespace]
      iex> Combine.parse("\t", optional_whitespace)
      [:whitespace]
      iex> Combine.parse(" \t", optional_whitespace)
      [:whitespace]
      iex> Combine.parse("", optional_whitespace)
      [:no_whitespace]
  """
  def optional_whitespace do
    many(either(space, tab))
    |> map(fn list when length(list) > 0 -> :whitespace
              _ -> :no_whitespace end)
  end

  # Date Parsers

  @doc """
  Expects and parses a 4 digit date.

      iex> import WealthPulse.Parsing.Parsers
      ...> Combine.parse("2016", year)
      [2016]
  """
  def year, do: fixed_integer(4)

  @doc """
  Expects and parses a 2 digit month.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("07", month)
      [7]
  """
  def month, do: fixed_integer(2)

  @doc """
  Expects and parses a 2 digit day.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("09", day)
      [9]
  """
  def day, do: fixed_integer(2)

  @doc """
  Expects and parses a date.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("2016-07-09", date)
      [{2016, 7, 9}]
  """
  def date do
    sequence([
      year,
      ignore(char("-")),
      month,
      ignore(char("-")),
      day
    ])
    |> map(fn [year, month, day] -> {year, month, day} end)
  end

  # Symbol Parsers

  @doc ~S"""
  Expects and parses a quoted symbol.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("\"MUTF25\"", quoted_symbol)
      [{"MUTF25", :quoted}]
  """
  def quoted_symbol do
    sequence([
      ignore(char("\"")),
      many1(satisfy(char, fn c -> !(c in String.codepoints("\"\r\n")) end)),
      ignore(char("\""))
    ])
    |> map(fn chars -> {Enum.join(chars), :quoted} end)
  end

  @doc """
  Expects and parses a non-quoted symbol.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("AAPL", non_quoted_symbol)
      [{"AAPL", :non_quoted}]
      iex> Combine.parse("$", non_quoted_symbol)
      [{"$", :non_quoted}]
  """
  def non_quoted_symbol do
    many1(satisfy(char, fn c -> !(c in String.codepoints("-0123456789; \"\t\r\n")) end))
    |> map(fn chars -> {Enum.join(chars), :non_quoted} end)
  end

  @doc ~S"""
  Expects and parses a quoted or non-quoted symbol.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("$", symbol)
      [{"$", :non_quoted}]
      iex> Combine.parse("\"MUTF25\"", symbol)
      [{"MUTF25", :quoted}]
  """
  def symbol, do: either(quoted_symbol, non_quoted_symbol)

  # Quantity parsers

  @doc """
  Expects and parses a quantity. Negative quantities should have a leading '-'.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("4,231.51", quantity)
      ["4231.51"]
      iex> Combine.parse("-45.22", quantity)
      ["-45.22"]
  """
  def quantity do
    sequence([
      option(char("-"))
      |> map(fn "-" -> "-"
                _ -> "" end),
      satisfy(char, fn c -> c in String.codepoints("0123456789") end),
      many(satisfy(char, fn c -> c in String.codepoints("0123456789,.") end))
    ])
    |> map(fn list ->
      list
      |> List.flatten
      |> Enum.join
      |> String.replace(",", "")
    end)
  end

  # Amount Parsers

  @doc """
  Expects and parses an amount in the form of symbol then quantity.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("$5.82", amount_symbol_then_quantity)
      [{"5.82", {"$", :non_quoted}, :symbol_left, :no_whitespace}]
      iex> Combine.parse("$ 5.82", amount_symbol_then_quantity)
      [{"5.82", {"$", :non_quoted}, :symbol_left, :whitespace}]
  """
  def amount_symbol_then_quantity do
    sequence([
      symbol,
      optional_whitespace,
      quantity
    ])
    |> map(fn [symbol, ws, qty] -> {qty, symbol, :symbol_left, ws} end)
  end

  @doc ~S"""
  Expects and parses an amount in the form of quantity then symbol.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("5.82 \"MUTF25\"", amount_quantity_then_symbol)
      [{"5.82", {"MUTF25", :quoted}, :symbol_right, :whitespace}]
      iex> Combine.parse("5.82\"MUTF25\"", amount_quantity_then_symbol)
      [{"5.82", {"MUTF25", :quoted}, :symbol_right, :no_whitespace}]
  """
  def amount_quantity_then_symbol do
    sequence([
      quantity,
      optional_whitespace,
      symbol
    ])
    |> map(fn [qty, ws, symbol] -> {qty, symbol, :symbol_right, ws} end)
  end

  @doc ~S"""
  Expects and parses an amount containing a symbol and quantity.

      iex> import WealthPulse.Parsing.Parsers
      iex> Combine.parse("$5.82", amount)
      [{"5.82", {"$", :non_quoted}, :symbol_left, :no_whitespace}]
      iex> Combine.parse("5.82 \"MUTF25\"", amount)
      [{"5.82", {"MUTF25", :quoted}, :symbol_right, :whitespace}]
  """
  def amount, do: either(amount_symbol_then_quantity, amount_quantity_then_symbol)

end