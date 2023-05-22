# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "NASM"
version_string = "2.16.01"
version = VersionNumber(version_string)

# Collection of sources required to complete build
sources = [
    ArchiveSource("https://www.nasm.us/pub/nasm/releasebuilds/$(version_string)/nasm-$(version_string).tar.xz",
                  "c77745f4802375efeee2ec5c0ad6b7f037ea9c87c92b149a9637ff099f162558"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/nasm-*
./autogen.sh 
./configure --prefix=${prefix} --build=${MACHTYPE} --host=${target}
make -j${nproc}
make install
install_license LICENSE
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    ExecutableProduct("ndisasm", :ndisasm),
    ExecutableProduct("nasm", :nasm)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6")
