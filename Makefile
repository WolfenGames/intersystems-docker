# == Makefile directives
# Configure the behaviour of Make itself.
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.ONESHELL:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

BUILD_ENV ?=

.Phony: build
build:
	cd ${BUILD_ENV} && docker build -t ${BUILD_ENV}-dxc:latest .

.Phony: launch
launch:
	docker-compose up -d

.Phony: fixperms
fixperms:
ifeq ($(BUILD_ENV), ensemble)
	@docker exec -it ${BUILD_ENV} chown -R cacheusr:cacheusr /opt/database
else ifeq ($(BUILD_ENV), iris)
	@docker exec -it -u 0 ${BUILD_ENV} chown -R irisowner:irisowner /opt/database
endif

.Phony: terminal
terminal:
	@docker exec -it ${BUILD_ENV} csession '${BUILD_ENV}' -UUSER

.Phony: install
install:
	@docker cp ${BUILD_ENV}/Installer.cls ${BUILD_ENV}:/tmp/Installer.cls
ifeq ($(BUILD_ENV),ensemble)
	@echo 'Do ##Class(%SYSTEM.OBJ).Load("/tmp/Installer.cls", "cuk")  H' | docker exec -i ${BUILD_ENV} csession '${BUILD_ENV}' -U %SYS > ensemble.import.txt
	@echo 'Do ##Class(${BUILD_ENV}.Installer).setup(.vars, 3)  H' | docker exec -i ${BUILD_ENV} csession '${BUILD_ENV}' -U %SYS >> ensemble.import.txt
else ifeq ($(BUILD_ENV),iris)
	@echo 'Do ##Class(%SYSTEM.OBJ).Load("/tmp/Installer.cls", "cuk")  H' | docker exec -i ${BUILD_ENV} iris terminal IRIS -U  %SYS > iris.import.txt
	@echo 'Do ##Class(${BUILD_ENV}.Installer).setup(.vars, 3)  H' | docker exec -i ${BUILD_ENV} iris terminal IRIS -U %SYS >> iris.import.txt
else
	@echo ${BUILD_ENV} Not supported
endif
