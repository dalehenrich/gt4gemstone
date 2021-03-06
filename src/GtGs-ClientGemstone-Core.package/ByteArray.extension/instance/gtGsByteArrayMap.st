*GtGs-ClientGemstone-Core
gtGsByteArrayMap
  "return a ByteArray mapping each ascii value to a 1 if that ascii value is in the set, and a 0 if it isn't.  Intended for use by primitives only"

  | map |
  map := ByteArray new: 256.
  1 to: map size do: [ :index | map at: index put: 0 ].
  self do: [ :ascii | map at: ascii + 1 put: 1 ].
  ^ map