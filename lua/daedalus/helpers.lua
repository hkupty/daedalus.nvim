local helpers = {}

helpers.auth = {}

helpers.auth.bearer = function(token)
  return "Bearer " .. vim.fn.expand(token)
end

helpers.auth.basic = function(user, pass)
  return vim.fn.expand(user)..':'..vim.fn.expand(pass)
end

return helpers
