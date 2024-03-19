# stage 1, library
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .
mkdir _build
cd _build

# We pass -DODE_WITH_LIBCCD_BOX_CYL:BOOL=OFF for consistency with autotools builds that are
# used by the ode packages of major linux distributions
# https://github.com/conda-forge/dartsim-feedstock/issues/62
# https://bitbucket.org/odedevs/ode/src/bcfb66cd5e18e32e27cfaae3651ead930bbcda13/configure.ac#lines-428
# https://bitbucket.org/odedevs/ode/issues/87/box-cylinder-ccd-check-disabled-by-default
cmake ${CMAKE_ARGS} -DCMAKE_BUILD_TYPE=Release \
      -DODE_WITH_LIBCCD:BOOL=ON \
      -DODE_WITH_LIBCCD_SYSTEM:BOOL=ON \
      -DODE_WITH_LIBCCD_BOX_CYL:BOOL=OFF \
      -DODE_WITH_DEMOS:BOOL=OFF \
      -DODE_WITH_TESTS:BOOL=OFF .. \
      -DCMAKE_INSTALL_PREFIX:PATH="" \
      -DCMAKE_INSTALL_LIBDIR="lib"

make VERBOSE=1
make install DESTDIR="${PREFIX}"
cd ..

# stage 2, bindings

# code has aliasing warnings, use flag to prevent crashes
export CFLAGS="-fno-strict-aliasing $CFLAGS"
cd bindings/python
${PYTHON} setup.py install --root "${PREFIX}" --prefix ""
