defmodule WealthPulse.Parsing.Parsers do
  import Combine.Parsers.Base
  import Combine.Parsers.Text
  import Combine.Helpers

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
      ...> Combine.parse("07", month)
      [7]
  """
  def month, do: fixed_integer(2)

  @doc """
  Expects and parses a 2 digit day.

      iex> import WealthPulse.Parsing.Parsers
      ...> Combine.parse("09", day)
      [9]
  """
  def day, do: fixed_integer(2)

  @doc """
  Expects and parses a date.

      iex> import WealthPulse.Parsing.Parsers
      ...> Combine.parse("2016-07-09", date)
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

end