# Analog Terminal Bell Software

The Analog Terminal Bell uses the GPIO pin of an MCP2221a to fire a solenoid
and hit the bell.  This is all done over USB.

## Configuring the Analog Terminal Bell

By default, the MCP2221a doesn't use GP0 as a general purpose IO, so we need to
configure it before using it.  This only needs to be done once, ever.  I use a
Ruby library called "UChip" to do the initial configuration:

```ruby
require "uchip/mcp2221"

# This example changes the "startup" GPIO settings of the chip.

# Find the first connected chip
chip = UChip::MCP2221.first || raise("Couldn't find the chip!")

# Get the GPIO settings
settings = chip.gp_settings

settings.gp0_designation = 0   # We want to use this pin as a GPIO
settings.gp0_output_value = 0  # Set the default value to 0
settings.gp0_direction = 0     # Set the direction to output

# Write the settings to the chip.  Next time the chip starts, the default
# settings for GP0 will reflect these settings
chip.gp_settings = settings
```

## Controlling the Analog Terminal Bell

The Analog Terminal Bell can be controlled with Circuit Python, but I don't
know how.  I've been testing it with a Ruby library called "UChip".  To install
the gem, just do `gem install uchip`.

Here is the code to control the bell with Ruby:

```ruby
require "uchip/mcp2221"

def hit_bell pin
  pin.value = 0
  pin.value = 1
  sleep 0.009
  pin.value = 0
end

# Find the first connected chip
chip = UChip::MCP2221.first || raise("Couldn't find the chip!")

pin = chip.pin 0
pin.output!

loop do
  hit_bell pin
  sleep 2
end
```

## Analog Terminal Bell and iTerm2

Currently the Analog Terminal Bell requires a custom build of iTerm2 to work.
Building from [this
branch](https://github.com/tenderlove/iTerm2/tree/analog-terminal-bell) will
enable the Analog Terminal Bell feature in iTerm2.
