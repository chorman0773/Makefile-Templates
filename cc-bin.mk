# Makefile template for (non-autotools) C projects



## User Variables Here
#
CC := cc
CFLAGS := -O2
LDFLAGS :=
CPPFLAGS := 

AR := ar

INSTALL := install

prefix := /usr/local
exec_prefix := $(prefix)
bindir := $(exec_prefix)/bin


## Program Specific Variables Here
# Modify Below this line

# src and output directories. Modify to your lieasure. Make sure to .gitignore OUTDIR
SRCDIR = src
OUTDIR = out

# Input the value of the -std flag for the compiler
CSTD := c11

# Directories to put in `-L` flags
LIBDIRS = 
# Libraries to put into `-l` flags
LIBS = 

# Additional flags to pass to the link step
EXTRA_LDFLAGS =

# Additional Libraries to pass as input to the ld step (but not as `-l` flags)

EXTERN_LIBS = 

# Form is $(OUTDIR)/%.o, which corresponds to $(SRCDIR)/%.c
OBJECTS = 

INCLUDE_DIRS = 
EXTRA_CFLAGS = 
EXTRA_CPPFLAGS =

# Header Files or directories to install
INSTALL_HEADERS = 

OUTPUTS =


## Computed Variables
# Do not not modify below this line

ALL_CPPFLAGS = $(foreach idir,$(INCLUDE_DIRS),-I $(idir)) $(EXTRA_CPPFLAGS) $(CPPFLAGS)
ALL_CFLAGS = $(EXTRA_CFLAGS) $(CFLAGS) -std=$(CSTD) -fPIC $(CFLAGS)

ALL_LDFLAGS = $(EXTRA_LD_FLAGS) $(foreach libdir,$(LIBDIRS),-L $(libdir))

DEPFILES = $(OBJECTS:.o=.o.d)

## Rules
# Do not modify below this line

all: stamp

.PHONY: all clean install install-headers $(foreach targ,$(OUTPUTS),install-${targ})

.DEFAULT: all

stamp: $(OUTPUTS)
	touch stamp

$(OUTPUTS): %: $(OBJECTS) $(EXTERN_LIBS)
	$(CC) $(ALL_CFLAGS) $(ALL_LDFLAGS) -o $@ $^ $(foreach lib,$(LIBS),-l$(lib))


$(OUTDIR)/%.o.d: $(SRCDIR)/%.c | $(OUTDIR)/
	$(CC) $(ALL_CPPFLAGS) -M -MT $(OUTDIR)/$*.o -MF $@ $<

$(OUTDIR)/%.o: $(SRCDIR)/%.c $(OUTDIR)/%.o.d 
	$(CC) $(ALL_CPPFLAGS) $(ALL_CFLAGS) -MD -MT $@ -MF $@.d -c $< -o $@ 

include $(DEPFILES)

$(OUTDIR)/: $(SUBDIRS:%=%/)
	mkdir $@

$(SUBDIRS:%=%/): %/: %/stamp

%/stamp: 
	+$(MAKE) -C $* stamp

%/clean: 
	+$(MAKE) -C $* clean

%/install: 
	+$(MAKE) -C $* install

clean: $(SUBDIRS:%=%/clean)
	rm -rf stamp $(OUTPUTS) $(OUTDIR)/

install: $(SUBDIRS:%=%/install)
	$(INSTALL) -m755 $(OUTPUTS) $(bindir)/

