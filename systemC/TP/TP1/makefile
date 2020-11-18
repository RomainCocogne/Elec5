

# définition des cibles particulières
.PHONY: clean mrproper

# Compilation
CXX=g++
INCLUDE=-I. -I$(SYSTEMC_PATH)/include
CFLAGS=$(INCLUDE) -Wall

# Linker
LDFLAGS=-L. -L$(SYSTEMC_LIB_PATH) -lsystemc

# Source
SOURCES=$(wildcard *.cpp)

# Object
OBJECTS=$(SOURCES:.cpp=.o)

# Executable
EXECUTABLE=main

all: $(SOURCES) $(EXECUTABLE)
	
$(EXECUTABLE): $(OBJECTS) 
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $@

.SUFFIXES: .cpp
.cpp.o:
	$(CXX) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS)
	
mrproper: clean
	rm -f $(EXECUTABLE)


