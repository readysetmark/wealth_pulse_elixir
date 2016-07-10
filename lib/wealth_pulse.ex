defmodule WealthPulse do
  alias WealthPulse.Parse, as: P

  def main(_args) do
    prices = P.price_db("/Users/mark/Nexus/Documents/finances/ledger/.pricedb")
    IO.puts "Loaded #{length prices} prices"
  end

end
