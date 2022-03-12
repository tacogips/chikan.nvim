# StrDeco
A string replacement neovim plugin, written in lua.


## Install and setup

```
-- with Packer
use({
  "tacogips/strdeco.nvim",
  config = function()
    require("strdeco").setup({})
  end,
})
```

## Usage
```
# on current line
:StrDeco <convertion_name>

# or on selected lines.(the rectangle selection is not supported)
:'<,'> StrDeco <convertion_name>

```

## Buildin functions

- to_snake_case
- to_camle_case
- to_json

## Custom function

you can write your own convert function
```lua
require("strdeco").setup({

  custom_conversion = {

    custom_conv = {
      before = function()
        return "ah .."
      end,
      convert = function(line, line_no, line_count)
        if string.match(line, "^%s*$") then
          return nil
        end
        line = string.gsub(line, "python", function(s)
          return "julia"
        end)

        line = string.gsub(line, "vim", function(s)
          return "neovim"
        end)
        return line
      end,
      after = function()
        return "now."
      end,
    },
  },
})
```