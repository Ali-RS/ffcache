SHELL=/bin/bash

PYTHON:=python3.8
PYTARGET:=ffcache$(shell ${PYTHON}-config --extension-suffix)
TARGET:=ffcache-linux-x86_64
CCOPT:=-std=c++11 -W -Wall $(shell ${PYTHON} -m pybind11 --includes)

all: $(TARGET) $(PYTARGET)

%.o: %.cpp
	g++ -fPIC $(CCOPT) -c -o $@ $^

$(PYTARGET): util.o structs.o ffcacheentry.o ffcacheindex.o httpheader.o ffcache.o pymain.o
	g++ $(CCOPT) -O3 -fPIC -shared $^ -lstdc++fs -lz -o $@

$(TARGET): util.o structs.o ffcacheentry.o ffcacheindex.o httpheader.o ffcache.o main.o
	g++ -static $(CCOPT) $^ -lstdc++fs -lz -o $@

clean:
	rm -f *.o $(TARGET) *.so

test:
	$(PYTHON) -c 'import ffcache'
