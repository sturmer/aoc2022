# Advent of code 2022

To bootstrap the project, I ran `mix new aoc2022` (I'd have preferred using a dash but Mix doesn't
allow that 🤷🏻).

That creates `lib/`, `test/` and a few other things. Then I copied the structure from my own AOC
2020 and made `day01.ex`. The `input/` directory creation is also my own hard (hah) work.

Then run tests with `mix test`. And do some `iex`. Today I'm very rusty with Elixir so I couldn't
remember almost any function. If I keep it up for a few days I may remember a thing or two of this
nice language!

## Import modules into iex
Just start iex as `iex -S mix` then e.g. `import Aoc2022.Day01`.
