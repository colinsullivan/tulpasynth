CFLAGS = -O2 -I./vendor/zaphoyd-websocketpp-ec28725/src
LDFLAGS = -lboost_system -lboost_date_time -lboost_regex -lboost_random  -lboost_program_options ./vendor/zaphoyd-websocketpp-ec28725/libwebsocketpp.a

CXX		?= c++

sound_server: sound_server.o sound.o
	# First build websocketpp (Makefile modified)
	(cd ./vendor/zaphoyd-websocketpp-ec28725;make;)

	$(CXX) $(CFLAGS) $^ -o $@ $(LDFLAGS)

%.o: %.cpp
	$(CXX) -c $(CFLAGS) -o $@ $^

# cleanup by removing generated files
#
.PHONY:		clean
clean:
	rm -f *.o sound_server
