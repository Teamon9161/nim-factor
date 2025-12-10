import math

template assertSeqAlmostEqual*(expected, actual: openArray[float]; eps: float = 1e-12) =
  ## Compare two float sequences/arrays with NaN awareness and tolerance.
  doAssert expected.len == actual.len, "length mismatch: expected " & $expected.len & ", got " & $actual.len
  for i in 0 ..< expected.len:
    let e = expected[i]
    let a = actual[i]
    if isNaN(e):
      doAssert isNaN(a), "idx " & $i & ": expected NaN, got " & $a
    else:
      doAssert abs(a - e) < eps, "idx " & $i & ": expected " & $e & ", got " & $a
