FILES=.bashrc .bash_profile .gitconfig z.sh .hushlogin .vimrc
FULL_SCRIPT_PATH=$(PWD)
UNAME=$(shell uname -a)

ifneq ($(findstring inux, $(UNAME)),)
    IS_LINUX=true
    IS_MAC=false
else
    IS_LINUX=false
    IS_MAC=true
endif

BACKUP_DIR=backup

.DEFAULT_GOAL=test

test:
	@echo "Show the results of variables that will be used in the Makefile"
	@echo "IS_LINUX             $(IS_LINUX)"
	@echo "IS_MAC               $(IS_MAC)"
	@echo "Source files         $(FULL_SCRIPT_PATH)"
	@echo "Home dir             $(HOME)"
	@echo "Files that will be linked:"
	@for FILE in $(FILES); do \
		echo "$$HOME/$$FILE -> $(FULL_SCRIPT_PATH)/$$FILE"; \
	done

remove-backup:
	@echo "Removing backup dir ($(BACKUP_DIR))"
	@rm -rf $(BACKUP_DIR)

backup:
	@mkdir $(BACKUP_DIR)
	@for FILE in $(FILES); \
	do \
		if [ -f $$HOME/$$FILE ]; \
		then \
			echo "Backing up '$$HOME/$$FILE' to '$(BACKUP_DIR)/$$FILE'"; \
			mv $$HOME/$$FILE $(BACKUP_DIR)/$$FILE; \
		fi; \
	done;
	#@rmdir --ignore-fail-on-non-empty $(BACKUP_DIR)

install: backup
	@echo "Installing dotfiles to '$(HOME)'"
	@for FILE in $(FILES); do \
		echo "Linking '$$HOME/$$FILE' to '$(FULL_SCRIPT_PATH)/$$FILE'"; \
		ln -sf "$(FULL_SCRIPT_PATH)/$$FILE" "$$HOME/$$FILE"; \
	done
	@echo "DOTFILES_PATH=\"$(FULL_SCRIPT_PATH)\"" > "$(HOME)"/.dotfiles_config

uninstall:
	@for FILE in $(FILES); do \
		rm -f $$HOME/$$FILE; \
	done
