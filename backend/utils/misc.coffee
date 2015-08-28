exports.filterObjectByKey = (object, allowedKey) ->
  result = {}
  result[key] = value for key, value of object when key in allowedKey
  result
