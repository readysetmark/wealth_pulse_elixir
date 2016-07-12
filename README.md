# Wealth Pulse

[![Build Status](https://travis-ci.org/readysetmark/wealth_pulse_elixir.svg?branch=master)](https://travis-ci.org/readysetmark/wealth_pulse_elixir)

Wealth Pulse is a web frontend for a [Ledger][1] journal file, supporting double-entry accounting
for personal finance tracking. Wealth Pulse only supports a subset of the Ledger journal file.

## How to Build and Run

Just getting started, so still TBD!

Get dependencies:

	mix deps.get

Building an "executable":

	mix escript.build
	./benchmark_parsing


## Installation

Also TBD!


## Tasks

Parsing
- [x] Parse pricedb file
- [ ] Parse ledger file
- [ ] Autobalance and validate ledger transactions
- [ ] Parse configuration file

Reporting
- [ ] Balance report
- [ ] Register report
- [ ] Networth chart
- [ ] Receivables and Liabilities




[1]: http://www.ledger-cli.org/