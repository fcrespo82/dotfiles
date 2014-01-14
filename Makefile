FILES=.bashrc
FILES+=.bash_profile
FILES+=.gitconfig
FILES+=z.sh
FILES+=.hushlogin
FULL_SCRIPT_PATH:=$(PWD)
UNAME:=$(shell uname -a)

ifneq ($(findstring inux, $(UNAME)),)
    IS_LINUX:=true
    IS_MAC:=false
else
    IS_LINUX:=false
    IS_MAC:=true
endif

.DEFAULT_GOAL:=test

test:
	@echo "REALPATH_DIR         $(REALPATH_DIR)"
	@echo "IS_LINUX             $(IS_LINUX)"
	@echo "IS_MAC               $(IS_MAC)"
	@echo "Source files         $(FULL_SCRIPT_PATH)"
	@echo "Home dir             $(HOME)"
	@echo "Files that will be linked:$(foreach FILE,$(FILES),\n$(HOME)/$(FILE) -> $(FULL_SCRIPT_PATH)/$(FILE))"

backup:
	@echo 'Backing up'

all: 
	@echo "$(FILES)"

# install: backup
# 	$(foreach FILE,$(FILES),$(shell ln -s $(HOME)/$(FILE) $(FULL_SCRIPT_PATH)/$(FILE)))