# vis-smart-backspace

This is a plugin for [vis] that rebinds the backspace so that it
deletes multiple spaces when at the start of the line, similar to vim's
`softtabstop` option.

[vis]: https://github.com/martanne/vis/

## Installation

Clone this repo into your vis plugins directory and add something like
this to your `visrc.lua`:

    local smart_backspace = require('plugins/vis-smart-backspace')
    smart_backspace.tab_width = 4

There is currently no good way for plugins to access your `tabwidth`
value so you will have to set it explicitly for now. This value is global
(i.e. the same for all windows) and defaults to 8.
