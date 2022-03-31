# This also packages up the base packages for the pre-loaded browser
# filesystem via `--preload-file`. Native libraries in .so files are
# pre-compiled with `--use-preload-plugins`.

EXTRA_FLAGS="${EXTRA_FLAGS:=}"
EXTRA_FLAGS+="../../library/grDevices/src/devCanvas.o "
if [[ ! -z "${BUILD_INTERNET-}" ]]; then
    EXTRA_FLAGS+="../../modules/internet/xhr.o "
    BUILD_ASYNC=1
fi
if [[ ! -z "${BUILD_ASYNC-}" ]]; then
    EXTRA_FLAGS+="-s ASYNCIFY -s ASYNCIFY_STACK_SIZE=1000000 "
fi

if [[ ! -z "${WEBR_REPO-}" ]]; then
    EXTRA_FLAGS+="--preload-file ${WEBR_REPO}@/repo "
fi
if [[ ! -z "${WEBR_LIB-}" ]]; then
    EXTRA_FLAGS+="--preload-file ${WEBR_LIB}@/usr/lib/R/library "
fi

mkdir -p src/main/bin
pushd src/main/bin
emcc -g -Oz -std=gnu11 -L/usr/local/lib -o R.bin.js ../Rmain.o ../CommandLineArgs.o ../Rdynload.o ../Renviron.o \
../RNG.o ../agrep.o ../altclasses.o ../altrep.o ../apply.o ../arithmetic.o ../array.o ../attrib.o ../bind.o \
../builtin.o ../character.o ../coerce.o ../colors.o ../complex.o ../connections.o ../context.o ../cum.o ../dcf.o \
../datetime.o ../debug.o ../deparse.o ../devices.o ../dotcode.o ../dounzip.o ../dstruct.o ../duplicate.o ../edit.o \
../engine.o ../envir.o ../errors.o ../eval.o ../format.o ../gevents.o ../gram.o ../gram-ex.o ../graphics.o ../grep.o \
../identical.o ../inlined.o ../inspect.o ../internet.o ../iosupport.o ../lapack.o ../list.o ../localecharset.o \
../logic.o ../main.o ../mapply.o ../match.o ../memory.o ../names.o ../objects.o ../options.o ../paste.o ../patterns.o \
../platform.o ../plot.o ../plot3d.o ../plotmath.o ../print.o ../printarray.o ../printvector.o ../printutils.o \
../qsort.o ../radixsort.o ../random.o ../raw.o ../registration.o ../relop.o ../rlocale.o ../saveload.o ../scan.o \
../seq.o ../serialize.o ../sort.o ../source.o ../split.o ../sprintf.o ../startup.o ../subassign.o ../subscript.o \
../subset.o ../summary.o ../sysutils.o ../times.o ../unique.o ../util.o ../version.o ../g_alab_her.o ../g_cntrlify.o \
../g_fontdb.o ../g_her_glyph.o ../xxxpr.o ${EXTRA_FLAGS} `ls ../../unix/*.o ../../appl/*.o ../../nmath/*.o` \
../../extra/tre/libtre.a ../../extra/blas/libRblas.a ../../extra/xdr/libxdr.a ${WEBR_INSTALL}/lib/libpcre2-8.a \
${FORTRAN_RUNTIME} ${WEBR_INSTALL}/lib/liblzma.a -lrt -ldl -lm \
--use-preload-plugins --preload-file ${WEBR_INSTALL}/lib/R@/usr/lib/R \
-s USE_BZIP2=1 -s USE_ZLIB=1 -s USE_LIBPNG=1 -s ERROR_ON_UNDEFINED_SYMBOLS=0 -s WASM_BIGINT -s WASM=1 \
-s ALLOW_MEMORY_GROWTH=1 -s MAIN_MODULE=1 -s ASSERTIONS=1 -s FETCH=1 -s NO_EXIT_RUNTIME=0

mkdir -p ${WEBR_DIST}
cp * ${WEBR_DIST}
