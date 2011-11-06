

#include <websocketpp.hpp>
#include <boost/asio.hpp>

#include "sound.hpp"

#include <iostream>

using boost::asio::ip::tcp;
using namespace socketsound;

int main(int argc, char* argv[]) {
	std::string host = "localhost";
	short port = 9003;
	std::string full_host;
	
	if (argc == 3) {
		// TODO: input validation?
		host = argv[1];
		port = atoi(argv[2]);
	}
		
	std::stringstream temp;
	
	temp << host << ":" << port;
	full_host = temp.str();

	socket_sound_handler_ptr sound_handler(new socket_sound_handler());
	
	
	try {
		boost::asio::io_service io_service;
		tcp::endpoint endpoint(tcp::v6(), port);
		
		websocketpp::server_ptr server(
			new websocketpp::server(io_service,endpoint,sound_handler)
		);
		
		// setup server settings
		server->add_host(host);
		server->add_host(full_host);
		// Chat server should only be receiving small text messages, reduce max
		// message size limit slightly to save memory, improve performance, and 
		// guard against DoS attacks.
		server->set_max_message_size(0xFFFF); // 64KiB
		
		// start the server
		server->start_accept();
		
		std::cout << "Starting sound server on " << full_host << std::endl;
		
		io_service.run();
	} catch (std::exception& e) {
		std::cerr << "Exception: " << e.what() << std::endl;
	}
	
	return 0;
}
