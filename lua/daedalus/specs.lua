-- Helpers for defining specs
local specs = {}

specs.define = function(opt)
  local default = opt['*'] or {}
  local url
  if default.url == nil then
    vim.api.nvim_err_writeln("You must specify a base url.")
    return nil
  else
    url = default.url
    default.url = nil
  end

  opt['*'] = nil

  vim.tbl_map(function(v)
    if v.path ~= nil then
      v.url = url .. v.path
      v.path = nil
    else
      vim.api.nvim_err_writeln("The spec is missing a path.")
      return nil
    end

    for key, defval in pairs(default) do
      if v[key] == nil then
        v[key] = defval
      end
    end

  end, opt)

  return opt
end

return specs
