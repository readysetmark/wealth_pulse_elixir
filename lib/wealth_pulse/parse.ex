defmodule WealthPulse.Parse do
  alias WealthPulse.Parse.Parsers, as: P

  @doc """
  Parse a .pricedb file.
  """
  def price_db(file) do
    [prices] = Combine.parse_file(file, P.price_db)
    prices
  end

end