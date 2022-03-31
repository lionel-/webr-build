WEBR_ROOT=$(abspath ..)
ROOT=$(abspath .)
INSTALL=$(WEBR_ROOT)/local

# Configure your local environment in this file
-include ~/.webr-config.mk

NUM_CORES ?= 4

BIN_FILES = build/bin/flang-new build/bin/tco build/bin/bbc

.PHONY: all
all: build/bin/flang-new

build/bin/flang-new: f18-llvm-project
	mkdir -p build && \
	cd build && \
	CMAKE_BUILD_PARALLEL_LEVEL=$(NUM_CORES) cmake ../f18-llvm-project/llvm \
	  -DCMAKE_INSTALL_PREFIX:PATH=$(INSTALL) \
	  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
	  -DLLVM_TARGETS_TO_BUILD="host;WebAssembly" \
	  -DLLVM_ENABLE_PROJECTS="clang;flang;mlir" \
	  -DCMAKE_CXX_STANDARD=17 \
	  -DLLVM_BUILD_TOOLS=On \
	  -DLLVM_INSTALL_UTILS=On && \
	make -j$(NUM_CORES)

.PHONY: wasm-runtime
wasm-runtime: build/bin/flang-new $(BUILD)/webr/libFortranRuntime.a

$(BUILD)/webr/libFortranRuntime.a:
	./build-runtime.sh

.PHONY: install
install: build/bin/flang-new build/webr/libFortranRuntime.a
	cp $(BIN_FILES) $(INSTALL)/bin
	cp build/webr/libFortranRuntime.a $(INSTALL)/lib

.PHONY: check
check:
	cd build && make check-flang

.PHONY: clean
clean:
	cmake --build build --target clean

f18-llvm-project:
	git clone --single-branch -b fix-webr --depth=1 https://github.com/lionel-/f18-llvm-project
