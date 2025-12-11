type
  RingBuffer* = object
    data: seq[float]
    pos: int
    filled: bool

proc initRingBuffer*(size: int): RingBuffer =
  if size <= 0:
    raise newException(ValueError, "size must be positive")
  RingBuffer(data: newSeq[float](size), pos: 0, filled: false)

proc push*(rb: var RingBuffer, x: float): float {.inline.}=
  ## Returns the value that is being evicted; NaN when the buffer is not full yet.
  let old = if rb.filled: rb.data[rb.pos] else: NaN
  rb.data[rb.pos] = x

  inc rb.pos
  if rb.pos == rb.data.len:
    rb.pos = 0
    rb.filled = true
  old
