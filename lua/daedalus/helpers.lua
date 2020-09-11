local helpers = {}

helpers.auth = {}

helpers.auth.bearer = function(token)
  return "Bearer " .. token
end


return helpers
