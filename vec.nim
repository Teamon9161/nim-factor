type
  Vec1*[T] = concept v
    len(v) is int
    v[0] is T

proc initOut*[T](xs: openArray[T]): seq[float] =
  newSeq[float](xs.len)

template ensure1D*[T](xs: openArray[T]) = discard
