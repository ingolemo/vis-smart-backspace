# vis-smart-backspace

This is a plugin for [vis] that rebinds the backspace so that it
deletes multiple spaces when at the start of the line, similar to vim's
`softtabstop` option.

[vis]: https://github.com/martanne/vis/

## Installation

Clone this repo into your vis plugins directory and add this to your
`visrc.lua`:

    require('plugins/vis-smart-backspace')
