-- Helpers for defining specs
local specs = {}

specs.define = function(opt)
  local default = opt['*'] or {}
  if default.url == nil then
    vim.api.nvim_err_writeln("You must specify a base url.")
    return nil
  end

  opt['*'] = nil

  vim.tbl_map(function(v)
    if v.path ~= nil then
      v.url = default.url .. v.path
      v.path = nil
    else
      vim.api.nvim_err_writeln("The spec is missing a path.")
      return nil
    end

    if default.auth ~= nil then
      v.auth = default.auth
    end

  end, opt)

  return opt
end

return specs
