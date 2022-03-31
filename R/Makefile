WEBR_ROOT=$(abspath ..)

ROOT=$(abspath .)
DOWNLOAD=$(ROOT)/download
BUILD=$(ROOT)/build
INSTALL=$(WEBR_ROOT)/local
DIST=$(WEBR_ROOT)/dist

# Configure your local environment in this file
-include ~/.webr-config.mk

EMFC=$(WEBR_ROOT)/tools/emfc
LOCAL_CFLAGS="$(CFLAGS) -fPIC -Oz"

LLVM_BUILD_DIR = $(WEBR_ROOT)/flang/build

R_VERSION=4.1.2
R_TARBALL=$(DOWNLOAD)/R-$(R_VERSION).tar.gz
R_SOURCE=$(BUILD)/R-$(R_VERSION)
R_PATCHES=$(ROOT)/patches/R-$(R_VERSION)
R_PATCHES2=$(WEBR_ROOT)/R/patches
R_URL=https://cran.r-project.org/src/base/R-4/R-$(R_VERSION).tar.gz

PCRE_VERSION=10.39
PCRE_TARBALL=$(DOWNLOAD)/pcre2-$(PCRE_VERSION).tar.gz
PCRE_URL=https://github.com/PhilipHazel/pcre2/releases/download/pcre2-${PCRE_VERSION}/pcre2-$(PCRE_VERSION).tar.gz

XZ_VERSION=5.2.5
XZ_TARBALL=$(DOWNLOAD)/xz-$(XZ_VERSION).tar.gz
XZ_URL=https://tukaani.org/xz/xz-$(XZ_VERSION).tar.gz/download

FORTRAN_RUNTIME=${INSTALL}/lib/libFortranRuntime.a
FORTRAN_LDFLAGS=-lFortranRuntime


.PHONY: all
all: R $(DIST)/index.html $(DIST)/webR.js

.PHONY: clean-state
clean-state:
	rm -f $(BUILD)/state

.PHONY: R
R: $(LLVM_BUILD_DIR)/bin/flang-new PCRE XZ $(BUILD)/state/r-stage2

$(DIST)/index.html:
	cp $(WEBR_ROOT)/loader/repl.html $(DIST)/index.html

$(DIST)/webR.js:
	cp $(WEBR_ROOT)/loader/webR.js $(DIST)/webR.js

$(BUILD)/state/r-stage1: $(BUILD)/state/r-stage1-configured
	cd $(R_SOURCE)/build && $(MAKE) R
	mv $(R_SOURCE)/build/etc/Renviron $(R_SOURCE)/build/etc/Renviron-orig
	echo "R_PLATFORM='wasm32-emscripten'\n" > $(R_SOURCE)/build/etc/Renviron
	cat $(R_SOURCE)/build/etc/Renviron-orig >> $(R_SOURCE)/build/etc/Renviron
	mkdir -p $(INSTALL)/lib/R/modules
	cp -a $(R_SOURCE)/build/etc $(INSTALL)/lib/R/etc
	cp -a $(R_SOURCE)/build/library $(INSTALL)/lib/R/library
	{ \
	  cd $(INSTALL)/lib/R/library; \
	  find . -type f -name '*.so' -exec rm -f {} \;; \
	}
	touch $@

$(BUILD)/state/r-stage1-configured: $(BUILD)/state/r-stage1-patched
	mkdir -p $(R_SOURCE)/build
	{ \
	  cd $(R_SOURCE)/build; \
	  CC="$(CC)" \
	  OBJC="$(OBJC)" \
	  CXX="$(CXX)" \
	  FC="$(FC)" \
	  F77="$(FC)" \
	  CFLAGS="$(STAGE1_CFLAGS)" \
	  LDFLAGS="$(STAGE1_LDFLAGS)" \
	  ../configure \
	    --prefix=$(INSTALL) \
	    --with-recommended-packages=no \
	    --enable-R-profiling=no \
	    --enable-byte-compiled-packages=no \
	    --with-x=no \
	    --with-aqua=no \
	    --with-readline=no \
	    --with-jpeglib=no \
	    --with-cairo=no \
	    --disable-openmp \
	    --with-pcre2 \
	    --disable-nls \
	    --with-internal-tzcode=no; \
	}
	touch $@

$(BUILD)/state/r-stage1-patched: $(R_TARBALL)
	rm -rf $(R_SOURCE)
	tar -C $(BUILD) -xf $(R_TARBALL)
	(cd $(R_SOURCE); patch -p1 < $(R_PATCHES)/stage1.patch)
	mkdir -p $(BUILD)/state
	touch $@

$(BUILD)/state/r-stage2: $(BUILD)/state/r-stage2-built
	$(MAKE) link
	touch $@

# This target is also useful to preload additional packages after a
# complete build
.PHONY: link
link:
	{ \
	  cd $(R_SOURCE); \
	  FORTRAN_RUNTIME="$(FORTRAN_RUNTIME)" \
	    WEBR_INSTALL="$(INSTALL)" \
	    WEBR_DIST="$(DIST)" \
	    WEBR_REPO="$(WEBR_REPO)" \
	    WEBR_LIB="$(WEBR_LIB)" \
	    $(ROOT)/link-R.sh; \
	}

R_INCLUDES = -I$(INSTALL)/include -I$(R_SOURCE)/build/src/include -I$(R_SOURCE)/src/include

$(BUILD)/state/r-stage2-built: $(BUILD)/state/r-stage2-patched
	{ \
	  cd $(R_SOURCE); \
	  FORTRAN_RUNTIME="$(FORTRAN_RUNTIME)" \
	    FORTRAN_LDFLAGS="$(FORTRAN_LDFLAGS)" \
	    WEBR_INSTALL="$(INSTALL)" \
	    WEBR_DIST="$(DIST)" \
	    R_SOURCE="$(R_SOURCE)" \
	    LLVM_BUILD_DIR="$(LLVM_BUILD_DIR)" \
	    EMFC="$(EMFC)" \
	    PKG_CFLAGS="$(R_INCLUDES) -fPIC -fvisibility=hidden -DNDEBUG -DHAVE_CONFIG_H -std=gnu11 -g -Oz $(CFLAGS)" \
	    PKG_LDFLAGS="-g -Oz -s WASM_BIGINT -s SIDE_MODULE=1 -L$(INSTALL)/lib $(LDFLAGS)" \
	    CFLAGS="$(R_INCLUDES) -fPIC -Wno-implicit-function-declaration -DHAVE_CONFIG_H -std=gnu11 -g -Oz $(CFLAGS)" \
	    CXXFLAGS="$(CXXFLAGS)" \
	    LDFLAGS="-g -Oz -s WASM_BIGINT -s SIDE_MODULE=1 -L$(INSTALL)/lib $(LDFLAGS)" \
	    $(ROOT)/build-R.sh; \
	}
	touch $@

# FIXME: Unhardcode
R_CPU = aarch64
R_VENDOR = apple
R_OS = darwin20.6.0

$(BUILD)/state/r-stage2-patched: $(BUILD)/state/r-stage1
	( \
	  cd $(R_SOURCE); \
	  patch --ignore-whitespace -p1 < $(R_PATCHES)/stage2.patch; \
	  patch -p1 < $(ROOT)/patches/0001-Fix-signature-mismatch-in-tre-xmalloc.c.patch; \
	)
	cat $(ROOT)/config-stat-time.h >> $(R_SOURCE)/build/src/include/config.h
	sed -i "" "s/$(R_CPU)/wasm32/g" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "s/$(R_OS)/emscripten/g" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define HAVE_LONG_DOUBLE/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define R_ARCH/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define USE_ICU/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define HAVE_ICONVLIST/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define HAVE___COSPI/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define HAVE___TANPI/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define HAVE___SINPI/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "/#define HAVE_UMASK/d" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "s|/\* #undef HAVE_VISIBILITY \*/|#define HAVE_VISIBILITY 1|" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "s|/\* #undef HAVE_VISIBILITY_ATTRIBUTE \*/|#define HAVE_VISIBILITY_ATTRIBUTE 1|" $(R_SOURCE)/build/src/include/config.h
	sed -i "" "s|/\* #undef HAVE_VISIBILITY_ATTRIBUTE \*/|#define HAVE_VISIBILITY_ATTRIBUTE 1|" $(R_SOURCE)/build/src/include/Rconfig.h
	touch $@

$(R_TARBALL):
	mkdir -p $(DOWNLOAD)
	wget $(R_URL) -O $@


$(LLVM_BUILD_DIR)/bin/flang-new:
	cd $(WEBR_ROOT)/flang && make && make install


.PHONY: XZ
XZ: $(INSTALL)/lib/liblzma.a

$(INSTALL)/lib/liblzma.a: $(XZ_TARBALL)
	mkdir -p $(BUILD)
	tar -C $(BUILD) -xf $(XZ_TARBALL)
	( \
	  cd $(BUILD)/xz-$(XZ_VERSION); \
	  mkdir -p build && cd build; \
	  CFLAGS=$(LOCAL_CFLAGS) emconfigure ../configure \
	    --enable-shared=no \
	    --enable-static=yes \
	    --prefix=$(INSTALL); \
	  emmake make install; \
	)
	touch $@

$(XZ_TARBALL):
	mkdir -p $(DOWNLOAD)
	wget $(XZ_URL) -O $@


.PHONY: PCRE
PCRE: $(INSTALL)/lib/libpcre2-8.a

$(INSTALL)/lib/libpcre2-8.a: $(PCRE_TARBALL)
	mkdir -p $(BUILD)
	tar -C $(BUILD) -xf $(PCRE_TARBALL)
	( \
	  cd $(BUILD)/pcre2-$(PCRE_VERSION); \
	  mkdir -p build && cd build; \
	  CFLAGS=$(LOCAL_CFLAGS) emconfigure ../configure \
	    --enable-shared=no \
	    --enable-static=yes \
	    --prefix=$(INSTALL); \
	  emmake make install; \
	)
	touch $@

$(PCRE_TARBALL):
	mkdir -p $(DOWNLOAD)
	wget -q -O $@ $(PCRE_URL)
