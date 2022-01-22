CC        := gcc

SRCDIR    := src
OBJDIR    := obj
BINDIR    := bin

TARGET    := example

SRCEXT    := c
DEPEXT    := d
OBJEXT    := o

CFLAGS    := -Wall  -Wextra -Wshadow -Wpointer-arith -Wcast-qual \
             -Wstrict-prototypes -Wmissing-prototypes -pedantic \
             -std=c99 -g -Iinc

SOURCES   := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT))
OBJECTS   := $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))
DEPENDS   := $(patsubst $(SRCDIR)/%,$(OBJDIR)/%,$(SOURCES:.$(SRCEXT)=.$(DEPEXT)))

.PHONY: clean build run $(TARGET)

build: $(BINDIR)/$(TARGET)

-include $(OBJECTS:.$(OBJEXT)=.$(DEPEXT))

run: $(BINDIR)/$(TARGET)
	$(BINDIR)/$(TARGET)

clean:
	rm -rf $(OBJECTS) $(DEPENDS) $(BINDIR)/$(TARGET)
	rm -rf $(OBJDIR)/*/

$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	$(shell mkdir -p $(@D))
	$(CC) -c $(CFLAGS) -o $@ $< -MD -MP

$(BINDIR)/$(TARGET): $(OBJECTS)
	$(CC) -o $@ $^
