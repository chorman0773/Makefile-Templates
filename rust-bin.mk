
## User Variables Here
#
RUSTC := rustc 
INSTALL := install

prefix := /usr/local
exec_prefix := $(prefix)
libdir := $(exec_prefix)/lib
bindir := $(exec_prefix)/bin

RUSTFLAGS := -C opt-level=2 

## Project-Specific Configuration

# The Rust Edition
RUSTSTD := 2018

SRCFILE = 

OUTPUTS = 

LIBDIRS = 

LIBRARIES 

EXTERN_LIBS =

EXTRA_RUSTFLAGS = 

CFGS = 


## Project-specific Rules


## Computed Variables
# Do not edit below this line

DEPFILES = $(OUTPUTS:%=%.d)

ALL_RUSTFLAGS = $(RUSTFLAGS) --edition $(RUSTSTD) $(EXTRA_RUSTFLAGS) \
				 $(foreach lib,$(EXTERN_LIBS),--extern $(lib)) \
				 $(foreach cfg,$(CFGS),--cfg $(cfg)) $(foreach libdir,$(LIBDIRS),-L $(libdir)) \
				 $(foreach lib,$(LIBRARIES),-l $(lib))

## Rules
# Do not edit below this line

$(filter %.so.d,$(OUTPUTS:%=%.d)): %.d: $(SRCFILE) $(EXTERN_LIBS)
	$(RUSTC) $(ALL_RUSTFLAGS) --emit dep-info=$@ --crate-name=$* $<

$(filter %.so,$(OUTPUTS)): %: %.d $(SRCFILE) $(EXTERN_LIBS)
	+$(RUSTC) $(ALL_RUSTFLAGS) --emit dep-info=$@.d --emit link=$@ --crate-type=bin --crate-name=$* $<


include $(DEPFILES)