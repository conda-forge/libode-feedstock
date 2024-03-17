# stage 1, library
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .
mkdir _build
cd _build

cmake ${CMAKE_ARGS} -DCMAKE_BUILD_TYPE=Release \
      -DODE_WITH_LIBCCD:BOOL=ON \
      -DODE_WITH_LIBCCD_SYSTEM:BOOL=ON \
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
