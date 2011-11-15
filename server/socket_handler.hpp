/**
 *  @file       socket_handler.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

#ifndef SOCKET_HANDLER_HPP
#define SOCKET_HANDLER_HPP

// client messages:
// 
// server messages:
// {"type":"buf","value":"[<samp>,...]"}

#include <boost/shared_ptr.hpp>
#include <websocketpp.hpp>
#include <websocket_connection_handler.hpp>
#include <Instrmnt.h>

#include <map>
#include <string>
#include <vector>

class socket_handler : public websocketpp::connection_handler {
public:
	socket_handler() {};
	socket_handler(std::vector<stk::Instrmnt*>* instrs) {
		this->instrs = instrs;
	};
	virtual ~socket_handler() {};
	
	void validate(websocketpp::session_ptr client); 
	
	// add new connection to the lobby
	void on_open(websocketpp::session_ptr client);
		
	// someone disconnected from the lobby, remove them
	void on_close(websocketpp::session_ptr client);
	
	void on_message(websocketpp::session_ptr client,const std::string &msg);
	
	// lobby will ignore binary messages
	void on_message(websocketpp::session_ptr client,
		const std::vector<unsigned char> &data) {}
	
	void send_to_all(std::string data);

private:
	std::string serialize_state();
	std::string encode_message(std::string sender,std::string msg,bool escape = true);
	std::string get_con_id(websocketpp::session_ptr s);

	// list of outstanding connections
	std::map<websocketpp::session_ptr,std::string> m_connections;

	// Keep references to instrument instances
	std::vector<stk::Instrmnt*>* instrs;
};

typedef boost::shared_ptr<socket_handler> socket_handler_ptr;

#endif
