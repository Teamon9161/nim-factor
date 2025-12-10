import math
import testing
import ring_buffer

type
  RollingMeanKind = enum
    rmExternal, rmManaged

  RollingMean*[K: static RollingMeanKind] = object
    window*: int
    minPeriods*: int
    sum: float
    count: int
    when K == rmManaged:
      ring: RingBuffer

  RollingMeanExternal* = RollingMean[rmExternal]
  RollingMeanManaged* = RollingMean[rmManaged]


proc normalizeMinPeriods(window: int; minPeriods: int): int =
  ## Validate and compute minPeriods; when 0, default to window div 2 (at least 1).
  if window <= 0:
    raise newException(ValueError, "window must be positive")
  let mp = if minPeriods == 0: max(1, window div 2) else: min(minPeriods, window)
  if mp < 0:
    raise newException(ValueError, "minPeriods must be greater than 0")
  mp

proc initRollingMean*(window: int; minPeriods: int = 0): RollingMeanExternal =
  ## Rolling mean accumulator; minPeriods is optional.
  let mp = normalizeMinPeriods(window, minPeriods)
  RollingMeanExternal(
    window: window,
    minPeriods: mp,
    sum: 0.0,
    count: 0,
  )

proc initRollingMeanManaged*(window: int; minPeriods: int = 0): RollingMeanManaged =
  ## Rolling mean accumulator that owns an internal ring buffer.
  let mp = normalizeMinPeriods(window, minPeriods)
  RollingMeanManaged(
    window: window,
    minPeriods: mp,
    sum: 0.0,
    count: 0,
    ring: initRingBuffer(window),
  )

proc updateImpl[T](rm: var T, newVal, oldVal: float): float =
  ## Incremental update logic shared by external/managed variants.
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

proc update*(rm: var RollingMeanExternal, newVal, oldVal: float): float =
  ## Incremental update with externally managed ring buffer.
  updateImpl(rm, newVal, oldVal)

proc update*(rm: var RollingMeanManaged, newVal: float): float =
  ## Incremental update using the managed ring buffer.
  let evicted = rm.ring.push(newVal)
  updateImpl(rm, newVal, evicted)

proc testRollingMean*() =
  ## Simple sanity test: feed an array, collect outputs, compare to expected.
  var rm = initRollingMeanManaged(3, 2)

  let inputs = [1.0, NaN, 3.0, 5.0]
  var outputs: seq[float] = @[]

  for x in inputs:
    outputs.add rm.update(x)

  let expected = @[NaN, NaN, 2.0, 4.0]
  assertSeqAlmostEqual(expected, outputs)

when isMainModule:
  testRollingMean()
