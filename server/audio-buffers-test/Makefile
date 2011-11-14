EXECUTABLE=sound_server

OBJS = 	$(EXECUTABLE).o \
		sound.o \
		RtAudio.o \
		RtAudioStream.o

PRECFLAGS = -O2 -ggdb -Wall \
	-I./vendor/zaphoyd-websocketpp-ec28725/src \
	-I./vendor/rtaudio-4.0.10

PRELDFLAGS = \
	-lstdc++ \
	-lm \
	-lboost_system \
	-lboost_date_time \
	-lboost_regex \
	-lboost_random  \
	-lboost_program_options \
	./vendor/zaphoyd-websocketpp-ec28725/libwebsocketpp.a

CXX		?= c++

PLATFORM=$(shell uname)

ifeq ($(PLATFORM),Linux)

CFLAGS = $(PRECFLAGS) -D__LINUX_ALSASEQ__ -D__UNIX_JACK__ -c
LDFLAGS = $(PRELDFLAGS) -lasound -lpthread -ljack

else

CFLAGS = $(PRECFLAGS) -D__MACOSX_CORE__ -c
LDFLAGS = $(PRELDFLAGS) -framework CoreAudio \
	-framework CoreMIDI \
	-framework CoreFoundation \
	-framework IOKit -framework Carbon

endif

$(EXECUTABLE): $(OBJS)
	# First build websocketpp (Makefile modified)
	(cd ./vendor/zaphoyd-websocketpp-ec28725;make;)

	$(CXX) -o sound_server $(OBJS) $(LDFLAGS)

RtAudio.o: ./vendor/rtaudio-4.0.10/RtAudio.cpp ./vendor/rtaudio-4.0.10/RtAudio.h ./vendor/rtaudio-4.0.10/RtError.h
	$(CXX) -c $(CFLAGS) ./vendor/rtaudio-4.0.10/RtAudio.cpp


%.o: %.cpp
	$(CXX) -c $(CFLAGS) -o $@ $^

# cleanup by removing generated files
#
.PHONY:		clean
clean:
	rm -f *.o sound_server
