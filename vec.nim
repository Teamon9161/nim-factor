
# proc initLike*[InT, OutT](_: typedesc[seq[InT]], len: int): seq[OutT] =
#   newSeq[OutT](len)

# # array[N, T] -> array[N, OutT]
# proc initLike*[InT, OutT; N: static[int]](_: typedesc[array[N, InT]], len: int): array[N, OutT] =
#   assert len == N
#   result = default(array[N, OutT])

proc uninit*[T](xs: seq[auto]; len: int): seq[T] =
  newSeq[T](len)