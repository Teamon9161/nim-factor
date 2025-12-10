import math
import testing

type
  RollingMean* = object
    window*: int
    minPeriods*: int
    sum: float
    count: int

  RingBuffer* = object
    data: seq[float]
    pos: int
    filled: bool


proc initRollingMean*(window: int; minPeriods: int = 0): RollingMean =
  ## Rolling mean accumulator; minPeriods is optional.
  ## When minPeriods==0 (not provided), it defaults to window div 2, at least 1.
  if window <= 0:
    raise newException(ValueError, "window must be positive")
  let mp = if minPeriods == 0: max(1, window div 2) else: minPeriods
  if mp <= 0 or mp > window:
    raise newException(ValueError, "minPeriods must be in 1..window")
  RollingMean(
    window: window,
    minPeriods: mp,
    sum: 0.0,
    count: 0,
  )

proc update*(rm: var RollingMean, newVal, oldVal: float): float =
  ## Incremental update:
  ## - oldVal is the value falling out of the window; pass NaN when none.
  ## - newVal is the value entering the window; pass NaN to skip.
  if not isNaN(oldVal):
    rm.sum -= oldVal
    dec rm.count

  if not isNaN(newVal):
    rm.sum += newVal
    inc rm.count

  if rm.count < rm.minPeriods:
    return NaN
  rm.sum / float(rm.count)

proc initRingBuffer*(size: int): RingBuffer =
  if size <= 0:
    raise newException(ValueError, "size must be positive")
  RingBuffer(data: newSeq[float](size), pos: 0, filled: false)

proc push*(rb: var RingBuffer, x: float): float =
  ## Returns the value that is being evicted; NaN when the buffer is not full yet.
  let old = if rb.filled: rb.data[rb.pos] else: NaN
  rb.data[rb.pos] = x

  inc rb.pos
  if rb.pos == rb.data.len:
    rb.pos = 0
    rb.filled = true
  old

proc testRollingMean*() =
  ## Simple sanity test: feed an array, collect outputs, compare to expected.
  var rb = initRingBuffer(3)
  var rm = initRollingMean(3, 2)

  let inputs = [1.0, NaN, 3.0, 5.0]
  var outputs: seq[float] = @[]

  for x in inputs:
    let evicted = rb.push(x)
    outputs.add rm.update(x, evicted)

  let expected = @[NaN, NaN, 2.0, 4.0]
  assertSeqAlmostEqual(expected, outputs)

when isMainModule:
  testRollingMean()
