#ifndef SOUND_HPP
#define SOUND_HPP

// client messages:
// 
// server messages:
// {"type":"buf","value":"[<samp>,...]"}

#include <boost/shared_ptr.hpp>
#include <websocketpp.hpp>
#include <websocket_connection_handler.hpp>

#include <map>
#include <string>
#include <vector>

namespace socketsound {

class socket_sound_handler : public websocketpp::connection_handler {
public:
	socket_sound_handler() {}
	virtual ~socket_sound_handler() {}
	
	void validate(websocketpp::session_ptr client); 
	
	// add new connection to the lobby
	void on_open(websocketpp::session_ptr client);
		
	// someone disconnected from the lobby, remove them
	void on_close(websocketpp::session_ptr client);
	
	void on_message(websocketpp::session_ptr client,const std::string &msg);
	
	// lobby will ignore binary messages
	void on_message(websocketpp::session_ptr client,
		const std::vector<unsigned char> &data) {}
private:
	std::string serialize_state();
	std::string encode_message(std::string sender,std::string msg,bool escape = true);
	std::string get_con_id(websocketpp::session_ptr s);
	
	void send_to_all(std::string data);
	
	// list of outstanding connections
	std::map<websocketpp::session_ptr,std::string> m_connections;
};

typedef boost::shared_ptr<socket_sound_handler> socket_sound_handler_ptr;

}
#endif // SOUND_HPP
