# daedalus.nvim

>  Daedalus was a skillful architect, craftsman and artist, and was seen as a symbol of wisdom, knowledge, and power. (...)

In order to call great APIs, we need great API clients.

Deadalus is a data-driven API client builder for neovim, in lua.

## How to use it?

Daedalus is intended to be used by plugin developers, so their clients can call remote APIs through their plugins.

It uses data to describe the APIs and returns a client that is able to call the endpoints:

```lua
local daedalus = require("daedalus")
local specs = require("daedalus.specs")
local helpers = require("daedalus.helpers")

local spec = specs.define{
  -- default attributes of the client specs
  ['*'] = {
    url = "https://api.github.com",
    handler = default_handler, -- you can specify default values that will be shared for all api specs
    auth = helpers.auth.bearer("$GITHUB_TOKEN") -- the bearer function expands env vars
  },
  issues = {
    path = "/issues",
    handler = issues_handler -- you can override global definitions per-api route
  },
  create_issue = {
    path = "/repos/${owner}/${repo}/issues",
    method = "post",

  }
}

-- if you don't supply any arguments, the default values will be used
spec.issues{}

-- if you need to override any default behavior, you can do so through arguments
spec.issues{
  before = function(cmd)
    -- if you need to extend the curl command or debug it before calling,
    -- override this function
    return cmd
  end,
  handler = function(ret)
    -- the handler function receives already parsed objects
    print(vim.inspect(ret))
  end,
  decode = function(str)
    -- if you need to parse values other than json, override this function
    return vim.fn.json_decode(str)
  end
}

spec.create_issue{
  urlargs = {
    owner = "hkupty",
    repo = "daedalus.nvim"
  },
  payload = {
      title = "Daedalus is awesome!",
      body = "I'm testing daedalus and I think it's amazing! Thanks :)"
  }

}

```
