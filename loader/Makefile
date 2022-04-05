WEBR_ROOT = $(abspath ..)
DIST = $(WEBR_ROOT)/dist

BASE_URL ?= "./"

.PHONY: all
all:
	sed -e "s|@@BASE_URL@@|$(BASE_URL)|" webR.js > $(DIST)/webR.js
	cp repl.html $(DIST)/index.html
