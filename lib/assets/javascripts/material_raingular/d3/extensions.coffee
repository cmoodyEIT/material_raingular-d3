Object.map = (obj) ->
  (func) ->
    func(key,val) for key,val of obj
Object.merge = (a,b,force) ->
  c = {}
  c[key] = val for key,val of a
  c[key] = val for key,val of b
  c
