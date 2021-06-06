# Makefile template for (non-autotools) C projects



## User Variables Here
#
CC := cc
CXX := c++
CFLAGS :=
CXXFLAGS := 
LDFLAGS :=
CPPFLAGS := 

AR := ar

INSTALL := install

prefix := /usr/local
exec_prefix := $(prefix)
libdir := $(exec_prefix)/lib
includedir := $(prefix)/include


## Program Specific Variables Here
# Modify Below this line

# src and output directories. Modify to your lieasure. Make sure to .gitignore OUTDIR
SRCDIR = src
OUTDIR = out

# Input the value of the -std flag for the compiler
CSTD := c11
CXXSTD := c++17

# Directories to put in `-L` flags
LIBDIRS = 
# Libraries to put into `-l` flags
LIBS = 

# Additional flags to pass to the link step
EXTRA_LDFLAGS =

# Additional Libraries to pass as input to the ld step (but not as `-l` flags)

EXTERN_LIBS = 

# Form is $(OUTDIR)/%.o, which corresponds to $(SRCDIR)/%.c or $(SRCDIR)/%.
OBJECTS = 

INCLUDE_DIRS = 
EXTRA_CFLAGS = 
EXTRA_CXXFLAGS = 
EXTRA_CPPFLAGS =

# Header Files or directories to install
INSTALL_HEADERS = 

OUTPUTS =


## Computed Variables
# Do not not modify below this line

ALL_CPPFLAGS = $(foreach idir,$(INCLUDE_DIRS),-I $(idir)) $(EXTRA_CPPFLAGS) $(CPPFLAGS)
ALL_CFLAGS = $(EXTRA_CFLAGS) $(CFLAGS) -std=$(CSTD) -fPIC
ALL_CXXFLAGS = $(EXTRA_CXXFLAGS) $(CXXFLAGS) -std=$(CXXSTD) -fPIC

ALL_LDFLAGS = $(EXTRA_LD_FLAGS) $(foreach libdir,$(LIBDIRS),-L $(libdir))

DEPFILES = $(OBJECTS:.o=.o.d)

## Rules
# Do not modify below this line

all: stamp

.PHONY: all clean install install-headers $(foreach targ,$(OUTPUTS),install-${targ})


stamp: $(OUTPUTS)
	touch stamp

$(filter %.so,$(OUTPUTS)): %.so: $(OBJECTS) $(EXTERN_LIBS)
	$(CXX) $(ALL_CXXFLAGS) $(ALL_LDFLAGS) -shared -o $@ $^ $(foreach lib,$(LIBS),-l$(lib))

$(filter %.a,$(OUTPUTS)): %.a: $(OBJECTS)
	$(AR) rcs $@ $^

$(OUTDIR)/%.o.d: $(SRCDIR)/%.c | $(OUTDIR)/
	$(CC) $(ALL_CPPFLAGS) -M -MT $(OUTDIR)/$*.o -MF $@ $<

$(OUTDIR)/%.o: $(SRCDIR)/%.c $(OUTDIR)/%.o.d 
	$(CC) $(ALL_CPPFLAGS) -MD -MT $@ -MF $@.d -c $< -o $@ 

$(OUTDIR)/%.o.d: $(SRCDIR)/%.cpp | $(OUTDIR)/
	$(CXX) $(ALL_CPPFLAGS) -M -MT $(OUTDIR)/$*.o -MF $@ $<

$(OUTDIR)/%.o: $(SRCDIR)/%.cpp $(OUTDIR)/%.o.d 
	$(CXX) $(ALL_CPPFLAGS) -MD -MT $@ -MF $@.d -c $< -o $@ 

$(OUTDIR)/%.o.d: $(SRCDIR)/%.cxx | $(OUTDIR)/
	$(CXX) $(ALL_CPPFLAGS) -M -MT $(OUTDIR)/$*.o -MF $@ $<

$(OUTDIR)/%.o: $(SRCDIR)/%.cxx $(OUTDIR)/%.o.d 
	$(CXX) $(ALL_CPPFLAGS) -MD -MT $@ -MF $@.d -c $< -o $@ 

include $(DEPFILES)

$(OUTDIR)/:
	mkdir $@

$(SUBDIRS:%=%/): %/: %/stamp

%/stamp: 
	make -C $(@D) stamp

clean:
	rm -rf $(OUTPUTS) $(OUTDIR)/

install: install-headers $(foreach targ,$(OUTPUTS),install-${targ})

install-%.a:
	$(INSTALL) -m644  $*.a $(libdir)/

install-%.so:
	$(INSTALL) -m755 $*.so $(libdir)/

install-headers:
	$(INSTALL) -m644 -t $(includedir)/ $(INSTALL_HEADERS)