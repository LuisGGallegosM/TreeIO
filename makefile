#LIBRARY MODULE
GCC:=g++
FLAGS:=-g -Wall -Wextra -Wpedantic -std=c++11
SOURCES:=$(shell find ./src -name "*.c" -or -name "*.cpp" )
TESTS:=$(shell find ./tests -name "*.c" -or -name "*.cpp" )
HEADERS:=$(shell find ./src -name "*.h")
OBJS:=$(patsubst ./src/%.cpp, build/%.o, ${SOURCES} )
DEPS:=$(patsubst %.o, %.d, ${OBJS} )
INSTALL_DIR:=${HOME}/.local
INC:=-I $(shell $(ROOTSYS)/bin/root-config --cflags)
LIBS:=$(shell $(ROOTSYS)/bin/root-config --ldflags --glibs) -lRooFit -lRooFitCore -lMinuit
NAME:=TreeIO
OUTPUT:=lib${NAME}.a

all: build/${OUTPUT}

-include ${DEPS}

document: build/${OUTPUT} docs/Doxyfile
	doxygen docs/Doxyfile
	xdg-open docs/html/index.html

build/${OUTPUT}: ${OBJS}
	@echo ">>build main target"
	ar rcs $@ ${OBJS}
	objdump -drCat -Mintel --no-show-raw-insn $@ > $@.s

clear:
	rm -r build/*
	rm -rf docs/html

build/%.o : src/%.cpp
	@echo ">>compile source $@"
	mkdir -p $(dir $@)
	${GCC} ${FLAGS} ${INC} -MMD -MP -c $< -o $@

build/test : build/${OUTPUT} ${TESTS}
	@echo ">>building $@"
	${GCC} ${TESTS} build/${OUTPUT} -lTester ${LIBS} ${FLAGS} -o $@

test: build/test
	./build/test

install: test uninstall
	@echo ">>installing to ${INSTALL_DIR}"
	mkdir -p ${INSTALL_DIR}/lib
	cp build/${OUTPUT} ${INSTALL_DIR}/lib/lib${NAME}.a
	mkdir -p ${INSTALL_DIR}/include/${NAME}
	for FILE in ${HEADERS}; do \
	F=$$(dirname $$FILE); \
	mkdir -p ${INSTALL_DIR}/include/${NAME}$${F#./src}; \
	cp $${FILE} ${INSTALL_DIR}/include/${NAME}$${FILE#./src}; \
	done

uninstall: 
	rm -f ${INSTALL_DIR}/lib/${OUTPUT}
	rm -rf ${INSTALL_DIR}/include/${NAME}