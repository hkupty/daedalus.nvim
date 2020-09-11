-- daedalus:
-- From greek mythology, built a labyrinth to constrain a minotaur.
--
-- This library allows for creating data-driven rest clients in lua.
-- Sample rest spec:
-- {
-- * = {
--  auth = "Bearer <toke
-- },
-- create = {
--    url = "https://some.endpoint/", -- static url
--    method = "post",
-- },
-- someAction = {
--    url = function(arg) return "https://some.endpoint/" .. arg end,
--    method = "post",
--    parser = function(ret)
--      -- Parses the content if not json
--    end
-- }}
--
-- It should be used as:
--
-- local client = daedalus.make_client(spec)
-- client.someAction{payload = {},
--   handler = function(ret)
--      -- do something with ret
--   end
-- }

arrow = function(coll)
  local nv = vim.deepcopy(coll[1])
  for _, fn in next, coll, 1 do
    nv = fn(nv)
  end
  return nv
end
local daedalus = {}

daedalus.default_spec = {
  before = function(obj) return obj end,
  parser = vim.fn.json_decode,
  handler = function(obj)
    vim.api.nvim_out_write("Please implement a handler for this API call.")
    vim.api.nvim_out_write(vim.inspect(obj))
    vim.api.nvim_out_write("\n")
    return obj
  end,
  method = "get"
}

daedalus.call = function(opt)
  tap(opt)
  local cmd = { "curl", "-s" }
  if opt.method ~= "get" then
    table.insert(cmd, "-X" .. opt.method)
  end

  if opt.payload ~= nil then
    table.insert(cmd, "-d")
    table.insert(cmd, opt.payload)
  end

  if opt.auth ~= nil then
    table.insert(cmd, "-H")
    table.insert(cmd, "Authorization: " .. opt.auth)
  end

  table.insert(cmd, opt.url)

  return arrow{
    cmd,
    opt.before,
    vim.fn.system,
    opt.parser,
    opt.handler
  }
end


daedalus.make_client = function(specs)
  local client_global_cfg = specs['*'] or {}

  return setmetatable({}, {
      __index = function(tbl, _spec)
        return function(opt)
          return tbl(_spec, opt)
        end
      end,
      __call = function(tbl, _spec, opt)
        return daedalus.call(vim.tbl_extend("force", daedalus.default_spec, client_global_cfg, specs[_spec], opt))
      end
  })
end

return daedalus
