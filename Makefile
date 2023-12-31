# find the OS
uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

# Compile flags for linux / osx
ifeq ($(uname_S),Linux)
	SHOBJ_CFLAGS ?=  -fno-common -g -ggdb
	SHOBJ_LDFLAGS ?= -shared -Bsymbolic
else
	SHOBJ_CFLAGS ?= -dynamic -fno-common -g -ggdb
	SHOBJ_LDFLAGS ?= -bundle -undefined dynamic_lookup -L$(shell xcode-select -p)/SDKs/MacOSX.sdk/usr/lib
endif
CFLAGS = -Wall -g -fPIC -lc -lm -std=gnu99
CC=gcc

.PHONY: all
all: module.so

module.so: module.o
	$(LD) -o $@ $^ $(SHOBJ_LDFLAGS) $(LIBS) -lc

.PHONY: clean
clean:
	rm -rf *.o *.so

