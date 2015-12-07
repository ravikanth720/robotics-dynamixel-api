CC  = c++
GCC = g++

CFLAGS  = -O -c
MYFLAGS = -O2 -Wall

LINUX_LIBS   = 
LIBS         = $(LINUX_LIBS)

SOURCE  = Dynamixel.cpp SerialPort.cpp Utils.cpp CPP_AXControl.cpp 
OBJECTS = Dynamixel.o SerialPort.o Utils.o CPP_AXControl.o

DEST = bAuto

RUBBISH = *.o *~ core $(DEST)

.SUFFIXES: .cpp .h

all: bAuto

.cpp.o:
	$(GCC) -c  $(MYFLAGS) $< -o $@

bAuto: $(OBJECTS)
	$(GCC) $(OBJECTS) -o $(DEST) $(LIBS)
clean:
	-rm -f $(RUBBISH)
