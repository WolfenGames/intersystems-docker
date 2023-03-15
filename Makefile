# == Makefile directives
# Configure the behaviour of Make itself.
ifeq ($(OS), Windows_NT)
SHELL := powershell.exe
.SHELLFLAGS := -Command
else
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
endif

.ONESHELL:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

BUILD_ENV ?= iris

.PHONY: OS
OS:
	@echo $(SHELL)

.PHONY: build
build:
	@cd ${BUILD_ENV} && docker build -t ${BUILD_ENV}-dxc:latest .

.PHONY: launch
launch:
	@docker-compose up -d

.PHONY: fixperms
fixperms:
ifeq ($(BUILD_ENV), ensemble)
	@docker exec -it ${BUILD_ENV} chown -R cacheusr:cacheusr /opt/database
else ifeq ($(BUILD_ENV), iris)
	@docker exec -it -u 0 ${BUILD_ENV} chown -R irisowner:irisowner /opt/database
endif

.PHONY: iterminal
iterminal:
ifeq ($(BUILD_ENV),ensemble)
	@docker exec -it ${BUILD_ENV} csession ${BUILD_ENV} -U USER
else
	@docker exec -it ${BUILD_ENV} iris terminal IRIS -U USER
endif

.PHONY: terminal
terminal:
ifeq ($(BUILD_ENV),ensemble)
	@docker exec -it ${BUILD_ENV} bash
else
	@docker exec -it -u 0 ${BUILD_ENV} bash
endif

.PHONY: install
install:
	@docker cp ${BUILD_ENV}/Installer.cls ${BUILD_ENV}:/tmp/Installer.cls
ifeq ($(BUILD_ENV),ensemble)
	@echo Do ##Class(%%SYSTEM.OBJ).Load("/tmp/Installer.cls", "cuk")  H | docker exec -i ${BUILD_ENV} csession ${BUILD_ENV} -U %%SYS
	@echo Do ##Class(${BUILD_ENV}.Installer).setup(.vars, 3)  H | docker exec -i ${BUILD_ENV} csession ${BUILD_ENV} -U %%SYS
else ifeq ($(BUILD_ENV),iris)
	@echo Do ##Class(%%SYSTEM.OBJ).Load("/tmp/Installer.cls", "cuk")  H | docker exec -i ${BUILD_ENV} iris terminal IRIS -U %%SYS
	@echo Do ##Class(${BUILD_ENV}.Installer).setup(.vars, 3)  H | docker exec -i ${BUILD_ENV} iris terminal IRIS -U %%SYS
else
	@echo ${BUILD_ENV} Not supported
endif

.PHONY: fixgit
fixgit: DOCKERCMD ?= ""
fixgit:
ifeq ($(BUILD_ENV),ensemble)
	@docker exec -t -u 0 ${BUILD_ENV} git config --global core.autocrlf true
	@docker exec -t -u 0 ${BUILD_ENV} git config --global --add safe.directory *
	@docker exec -t ${BUILD_ENV} git config --global core.autocrlf true
	@docker exec -t ${BUILD_ENV} git config --global --add safe.directory *
else ifeq ($(BUILD_ENV),iris)
	@docker exec -t -u 0 ${BUILD_ENV} apt update -y
	@docker exec -t -u 0 ${BUILD_ENV} apt install -y git
	@docker exec -t -u 0 ${BUILD_ENV} git config --global --add safe.directory *
	@docker exec -t -u 0 ${BUILD_ENV} git config --global core.autocrlf true
	@docker exec -t ${BUILD_ENV} git config --global core.autocrlf true
	@docker exec -t ${BUILD_ENV} git config --global --add safe.directory *
else ifeq ($(BUILD_ENV),fhir-iris)
	@docker exec -t -u 0 ${BUILD_ENV} apt update -y
	@docker exec -t -u 0 ${BUILD_ENV} apt install -y git
	@docker exec -t -u 0 ${BUILD_ENV} git config --global --add safe.directory *
	@docker exec -t -u 0 ${BUILD_ENV} git config --global core.autocrlf true
	@docker exec -t ${BUILD_ENV} git config --global core.autocrlf true
	@docker exec -t ${BUILD_ENV} git config --global --add safe.directory *
else
	@echo "Sorry bill, not today"
endif