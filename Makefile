OUT                = chromium-launcher launcher-derp

PREFIX            ?= /usr/local
PEPPER_FLASH_DIR  ?= /usr/lib/PepperFlash
CHROMIUM_BIN      ?= /usr/lib/chromium/chromium

CHROMIUM_SUFFIX   ?=

override CFLAGS   += -std=c99 $(shell pkg-config --cflags gtk+-2.0)
override LDLIBS   += $(shell pkg-config --libs gtk+-2.0)

LAUNCHER_DIR      := $(PREFIX)/lib/chromium-launcher$(CHROMIUM_SUFFIX)
LAUNCHER_DERP     := $(LAUNCHER_DIR)/launcher-derp

all: chromium-launcher launcher-derp

chromium-launcher: chromium-launcher.in
	sed \
		-e "s|@PEPPER_FLASH_DIR@|$(PEPPER_FLASH_DIR)|g" \
		-e "s|@CHROMIUM_BIN@|$(CHROMIUM_BIN)|g" \
		-e "s|@LAUNCHER_DERP@|$(LAUNCHER_DERP)|g" \
		$< >$@

install: all
	install -Dm755 chromium-launcher "$(DESTDIR)$(LAUNCHER_DIR)/chromium-launcher"
	install -Dm755 launcher-derp "$(DESTDIR)$(LAUNCHER_DIR)/launcher-derp"
	ln -fsr $(LAUNCHER_DIR)/chromium-launcher "$(DESTDIR)$(PREFIX)/bin/chromium$(CHROMIUM_SUFFIX)"


uninstall:
	$(RM) "$(DESTDIR)$(LAUNCHER_DIR)/chromium-launcher"
	$(RM) "$(DESTDIR)$(LAUNCHER_DIR)/launcher-derp"
	$(RM) "$(DESTDIR)$(PREFIX)/bin/chromium$(CHROMIUM_SUFFIX)"
	rmdir "$(DESTDIR)$(LAUNCHER_DIR)"

clean:
	$(RM) $(OUT)

.PHONY: all clean install uninstall