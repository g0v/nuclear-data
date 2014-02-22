# ----------------------------------------------------------------------------
# Configurations
# ----------------------------------------------------------------------------

TOP_DIR             = $(abspath .)
RUNTIME_DIR         = $(TOP_DIR)/runtime
CACHE_DIR           = $(TOP_DIR)/cache

VIRTUALENV_VERSION  = 1.11.4


# ----------------------------------------------------------------------------
# Main targets
# ----------------------------------------------------------------------------

.PHONY: all
all: help

.PHONY: help
help:
	@echo "Usage: make [ TARGET ... ]";
	@echo "";
	@echo "TARGET:";
	@echo "";
	@echo "  help      - show this help message";
	@echo "  runtime   - create a virtual runtime environment";
	@echo "  shell     - run a python shell in the virtual runtime";
	@echo "  python-%  - install the python % in the virtual runtime";
	@echo "  clean     - delete all generated files";
	@echo "  distclean - delete all generated files and caches";
	@echo "";
	@echo "Default TARGET is 'help'.";

.PHONY: clean
clean:
	rm -rf $(RUNTIME_DIR);

.PHONY: distclean
distclean: clean
	rm -rf $(CACHE_DIR);

.PHONY: shell
shell: runtime
	( source $(RUNTIME_DIR)/bin/activate; python; deactivate; );

.PHONY: runtime
runtime: $(RUNTIME_DIR)/bin/python

$(RUNTIME_DIR)/bin/python: $(CACHE_DIR)/virtualenv/virtualenv.py
	# TODO: Replaces tar(1) with the built-in os.makedirs() function of python.
	mkdir -p $(RUNTIME_DIR);
	python $(CACHE_DIR)/virtualenv/virtualenv.py $(RUNTIME_DIR);

$(CACHE_DIR)/virtualenv/virtualenv.py: $(CACHE_DIR)/virtualenv-$(VIRTUALENV_VERSION).tar.gz
	mkdir -p $(CACHE_DIR)/virtualenv;
	# TODO: Replaces tar(1) with the built-in tarfile module of python.
	tar -zmx -C $(CACHE_DIR)/virtualenv --strip-components 1 -f $<;

$(CACHE_DIR)/virtualenv-$(VIRTUALENV_VERSION).tar.gz:
	# TODO: Replaces curl(1) with the built-in urllib2 module of python.
	( mkdir -p $(CACHE_DIR); cd $(CACHE_DIR); curl --remote-name \
	https://pypi.python.org/packages/source/v/virtualenv/virtualenv-$(VIRTUALENV_VERSION).tar.gz; );

python-%: $(RUNTIME_DIR)/bin/python
	( cd $(RUNTIME_DIR); source bin/activate; \
	  pip install --download-cache $(CACHE_DIR)/pip \
	  $(patsubst python-%,%,$@); deactivate; );


# ----------------------------------------------------------------------------
# Special targets
# ----------------------------------------------------------------------------

.PHONY: nuclear-runtime
nuclear-runtime: python-bottle

.PHONY: nuclear-init
nuclear-init:
	sqlite3 nuclear-data.db < nuclear-data.sql;

.PHONY: run
run: nuclear-runtime
	( source $(RUNTIME_DIR)/bin/activate; \
	  python nuclear-server.py; deactivate; );


