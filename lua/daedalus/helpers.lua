local helpers = {}

helpers.auth = {}

helpers.auth.bearer = function(token)
  return "Bearer " .. vim.fn.expand(token)
end


return helpers
