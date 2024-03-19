ECHO "stage 1, library"

mkdir _build
cd _build
env

REM add future installation path to pkgconfig
set PKG_CONFIG_PATH=%LIBRARY_PREFIX%\lib\pkgconfig;

REM We pass -DODE_WITH_LIBCCD_BOX_CYL:BOOL=OFF for consistency with autotools builds that are
REM used by the ode packages of major linux distributions
REM https://github.com/conda-forge/dartsim-feedstock/issues/62
REM https://bitbucket.org/odedevs/ode/src/bcfb66cd5e18e32e27cfaae3651ead930bbcda13/configure.ac#lines-428
REM https://bitbucket.org/odedevs/ode/issues/87/box-cylinder-ccd-check-disabled-by-default
cmake -G"NMake Makefiles" ^
      -DODE_WITH_LIBCCD:BOOL=ON ^
      -DODE_WITH_LIBCCD_SYSTEM:BOOL=ON ^
      -DODE_WITH_LIBCCD_BOX_CYL:BOOL=OFF ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DODE_WITH_DEMOS:BOOL=OFF ^
      -DODE_WITH_TESTS:BOOL=OFF ^
      -DCMAKE_INSTALL_PREFIX:PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_PREFIX_PATH:PATH=%LIBRARY_PREFIX% ^
      ..
if errorlevel 1 exit 1

nmake VERBOSE=1
if errorlevel 1 exit 1

nmake install VERBOSE=1
if errorlevel 1 exit 1
 
cd ..

ECHO "stage 2, bindings"
cd bindings\python

ECHO "check pkgconfig output"
pkg-config --cflags ode
pkg-config --libs ode
ECHO "PKG_CONFIG_PATH %PKG_CONFIG_PATH%"
set PATH=%PATH%:%LIBRARY_PREFIX%\bin

python -m pip install . -vv
REM python setup.py install --verbose
if errorlevel 1 exit 1
REM --root %PREFIX% --prefix ""
