/**
 *  @file       socket_handler.hpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the GPLv3 license.
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

using websocketpp::session_ptr;


#include "Orchestra.hpp"


class socket_handler : public websocketpp::connection_handler {
public:
	socket_handler() {};
	socket_handler(Orchestra* orchestra) {
		this->orchestra = orchestra;
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
	/**
	 *  Send message to all clients except for one.
	 *
	 *	@param  data  	Message to send to clients
	 *	@param  one  	Client to NOT send the message to.
	 **/
	void send_to_all_but_one(std::string data, session_ptr one);
private:
	std::string serialize_state();
	std::string encode_message(std::string sender,std::string msg,bool escape = true);
	std::string get_con_id(websocketpp::session_ptr s);

	// list of outstanding connections
	std::map<websocketpp::session_ptr,std::string> m_connections;

	// Keep reference to orchestra
	Orchestra* orchestra;
};

typedef boost::shared_ptr<socket_handler> socket_handler_ptr;

#endif
