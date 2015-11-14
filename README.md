# JequalSON
[![Build Status](https://travis-ci.org/dm1try/jequalson.svg)](https://travis-ci.org/dm1try/jequalson)
[![Coverage Status](https://coveralls.io/repos/dm1try/jequalson/badge.svg?branch=master&service=github)](https://coveralls.io/github/dm1try/jequalson?branch=master)
## Usage
For example, lets check that a first user in twitter response matches a provided schema:
```elixir
  # assume that you use Poison to parse responses
  response = Poison.Parser.parse!(twitter_response)

  JequalSON.match? response, "statuses[0].user", %{
    name: "Sean Cummings",
    id_str: :string,
    followers_count: :integer,
    entities: %{
      url: :object
    }
  }
```
See specs for more examples.

## Path
Path can include specific characters for collections:
 __*__ - means **all**,
 __?__ - means **any**

```elixir
  # all statuses
  JequalSON.match? response, "statuses[*]", %{...}

  # any of statuses
  JequalSON.match? response, "statuses[?]", %{...}
```

## Schema
Matching can be done for a value ifself or for its type. Also you can define own matching function.
```elixir
    hex_color = fn(v)->
      Regex.match?(~r/^[A-F0-9]{6}$/, v)
        or {:failure, "#{v} is not hex a color"}
    end

    JequalSON.match? response, "statuses[0].user", %{
        name: "Sean Cummings",
        id_str: :string, # use the atom to specify a type
        profile_background_color: hex_color # use the func defined above
      }
```

## Installation
  1. Add JequalSON to your list of dependencies in `mix.exs`:

        def deps do
          [{:jequalson, "~> 0.1"}]
        end

## ESpec/ExUnit matchers

  TODO

## Inspirations

API testing framework [Airborne](https://github.com/brooklynDev/airborne)
