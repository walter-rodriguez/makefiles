# Tareas para Golang

# ==================================================================================== #
# Definir en .env las variables:
# GOMAIN - Ubicación del Archivo main de la aplicación
# GOARGS - Argumentos de la aplicación o una cadena vacía si no se requiere
# PROJECTNAME - Nombre del proyecto
# BIN - Nombre del ejecutable, de preferencia que sea una palabra alfanumerica con la
#       cantidad de caracteres minima y en minusculas
# ==================================================================================== #



# Linker flags
LDFLAGS="-X 'main.Version=$(VERSION)' -X 'main.Compilacion=$(BUILD)'"
# variables de ubicacion
GOBASE := $(shell pwd)
GOBIN := $(GOBASE)/bin


.PHONY: require
require:
	@go version >/dev/null 2>&1 || (echo "$(RED)!! Error: go es requerido$(RESET)"; exit 1)
	@reflex >/dev/null 2>&1 || (echo "$(RED)!! Error: reflex es requerido$(RESET)"; exit 1)

## build: Compila el proyecto Go
.PHONY: build
build:
	@mkdir -p $(GOBIN)
	go build -ldflags $(LDFLAGS) -o $(GOBIN)/$(BIN) $(GOMAIN)
	@echo "$(GOBIN)/$(BIN) COMPILADO!!"

## watch: Mantiene la ultima version activa y se recompila cuando se modifique algun archivo Go
.PHONY: watch
watch:
	@reflex -r '\.go$$' -- make run

## clean: limpia los resultados de la compilacion y el binario generado
.PHONY: clean
clean:
	@-rm $(GOBIN)/$(BIN) 2> /dev/null
	@go clean

## audit: Se realiza el formateo, 'Vetting' y testing del proyecto
.PHONY: audit
audit:
	@echo -e "\033[33m>> Formatting code...\033[0m"
	go fmt ./...
	@echo -e "\033[33m>> Vetting code...\033[0m"
	go vet ./...
	staticcheck ./...
	@echo -e "\033[33m>> Running tests...\033[0m"
	go test -race -vet=off ./...

## test: Ejecuta las pruebas de la aplicacion
.PHONY: test
test:
	@go test ./...

