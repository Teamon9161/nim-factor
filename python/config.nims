# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config

# Build tuning for Python extension: enable aggressive CPU flags.
switch("passC", "-ffast-math")
# switch("passL", "-march=native")
switch("d", "danger")
