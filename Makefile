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
	@docker exec -it ${BUILD_ENV} chown -R cacheusr:cacheusr /opt/database
	# @docker exec -it ${BUILD_ENV} chown -R cacheusr:cacheusr /home/repos

.Phony: terminal
terminal:
	@docker exec -it ${BUILD_ENV} csession '${BUILD_ENV}' -UUSER

.Phony: install
install:
ifeq ($(BUILD_ENV),ensemble)
	@docker cp ${BUILD_ENV}/Installer.cls ${BUILD_ENV}:/tmp/Installer.cls
	@echo 'Do ##Class(%SYSTEM.OBJ).Load("/tmp/Installer.cls", "cuk")  H' | docker exec -i ${BUILD_ENV} csession '${BUILD_ENV}' -U %SYS > import.txt
	@echo 'Do ##Class(${BUILD_ENV}.Installer).setup(.vars, 3)  H' | docker exec -i ${BUILD_ENV} csession '${BUILD_ENV}' -U %SYS >> import.txt
else
	@echo ${BUILD_ENV} Not supported
endif
