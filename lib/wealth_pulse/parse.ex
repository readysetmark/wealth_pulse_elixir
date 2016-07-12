defmodule WealthPulse.Parse do
  alias WealthPulse.Parse.Parsers, as: P
  alias WealthPulse.Core.Price

  @doc """
  Parse a .pricedb file.
  """
  @spec price_db(String.t()) :: [Price.t()]
  def price_db(file) do
    [prices] = Combine.parse_file(file, P.price_db)
    prices
  end

end