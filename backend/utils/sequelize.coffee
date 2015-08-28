exports.sequelizeObject = (seq, attrs) ->
  result = {}
  for attr in attrs
    value = seq.get(attr)

    # Convert date to EPOCH format
    if value instanceof Date
      value = value.valueOf()

    result[attr] = value
  result
