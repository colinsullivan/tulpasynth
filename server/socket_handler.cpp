/**
 *  @file       socket_handler.cpp
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


#include "socket_handler.hpp"

#include "instruments/Glitch.hpp"

#include <boost/algorithm/string/replace.hpp>
#include <json/reader.h>
#include <json/writer.h>
#include <json/value.h>

using websocketpp::session_ptr;

void socket_handler::validate(session_ptr client) {
	std::stringstream err;
	
	// We only know about the sound resource
	if (client->get_resource() != "/") {
		err << "Request for unknown resource " << client->get_resource();
		throw(websocketpp::handshake_error(err.str(),404));
	}
	
	// Require specific origin example
	// if (client->get_origin() != "http://basillamus.stanford.edu:8080") {
		// err << "Request from unrecognized origin: " << client->get_origin();
		// throw(websocketpp::handshake_error(err.str(),403));
	// }
}

void socket_handler::on_open(session_ptr client) {
	std::cout << "client " << client << " connected." << std::endl;
	m_connections.insert(std::pair<session_ptr,std::string>(client,get_con_id(client)));

	// send user list and signon message to all clients
	// send_to_all(serialize_state());
	// client->send(encode_message("server","Welcome, use the /alias command to set a name, /help for a list of other commands."));
	// send_to_all(encode_message("server",m_connections[client]+" has joined the chat."));
}

void socket_handler::on_close(session_ptr client) {
	std::map<session_ptr,std::string>::iterator it = m_connections.find(client);
	
	if (it == m_connections.end()) {
		// this client has already disconnected, we can ignore this.
		// this happens during certain types of disconnect where there is a
		// deliberate "soft" disconnection preceeding the "hard" socket read
		// fail or disconnect ack message.
		return;
	}
	
	std::cout << "client " << client << " disconnected." << std::endl;
	
	const std::string alias = it->second;
	m_connections.erase(it);

	// send user list and signoff message to all clients
	// send_to_all(serialize_state());
	// send_to_all(encode_message("server",alias+" has left the chat."));
}

void socket_handler::on_message(session_ptr client,const std::string &msg) {
	std::cout << "message from client " << client << ": " << msg << std::endl;
	Json::Value messageObject;
	Json::Reader reader;

	bool parsingSuccessful = reader.parse(msg, messageObject);
	if ( !parsingSuccessful ) {
	    // report to the user the failure and their locations in the document.
	    std::cout  << "Failed to parse configuration\n"
	               << reader.getFormattedErrorMessages();
	    return;
	}

	std::string method = messageObject["method"].asString();


	Json::Value outgoingMessageObject;
	Json::StyledWriter writer;


	// What are we doing
	if(method == "request/id") {
		// Respond with next instrument id
		outgoingMessageObject["method"] = "response/id";
		outgoingMessageObject["id"] = this->orchestra->generate_instrument_id();
		client->send(writer.write(outgoingMessageObject));
	}
	else if(method == "create") {
		// We're creating a new instrument model of a certain type
		std::string clientModelNamespace = messageObject["namespace"].asString();

		std::cout << "Creating new " << clientModelNamespace << " object" << std::endl;

		instruments::Instrument* newInstr = NULL;

		if(clientModelNamespace == "hwfinal.models.instruments.Glitch") {
			// Create new glitch object (this will automatically get added to orchestra)
			newInstr = (instruments::Instrument*)new instruments::Glitch(this->orchestra, messageObject["attributes"], 14);
		}
		else {
			std::cerr << "Namespace " << clientModelNamespace << " unrecognized." << std::endl;
			return;
		}

		// Serialize model and relay to all clients
		outgoingMessageObject["method"] = "create";
		outgoingMessageObject["namespace"] = messageObject["namespace"];
		outgoingMessageObject["attributes"] = newInstr->get_attributes();

		std::string outgoingMessage = writer.write(outgoingMessageObject);
		std::cout << "outgoingMessage:\n" << outgoingMessage << std::endl;

		this->send_to_all_but_one(msg, client);

		// Also relay original client with same info but in an "update" message
		outgoingMessageObject["method"] = "update";

		outgoingMessage = writer.write(outgoingMessageObject);
		std::cout << "outgoingMessage to single client:\n" << outgoingMessage << std::endl;
		client->send(outgoingMessage);


	}
	else if(method == "update") {
		// Get instrument.
		instruments::Instrument* instr = this->orchestra->get_instrument(messageObject["attributes"]["id"].asInt());

		// Save its attributes
		instr->set_attributes(messageObject["attributes"]);

		// Relay to all other clients
		this->send_to_all_but_one(msg, client);

	}
	else {
		std::cerr << "Method " << method << " unrecognized." << std::endl;
		return;
	}


	
	// // check for special command messages
	// if (msg == "/help") {
	// 	// print command list
	// 	client->send(encode_message("server","avaliable commands:<br />&nbsp;&nbsp;&nbsp;&nbsp;/help - show this help<br />&nbsp;&nbsp;&nbsp;&nbsp;/alias foo - set alias to foo",false));
	// 	return;
	// }
	
	// if (msg.substr(0,7) == "/alias ") {
	// 	std::string response;
	// 	std::string alias;
		
	// 	if (msg.size() == 7) {
	// 		response = "You must enter an alias.";
	// 		client->send(encode_message("server",response));
	// 		return;
	// 	} else {
	// 		alias = msg.substr(7);
	// 	}
		
	// 	response = m_connections[client] + " is now known as "+alias;

	// 	// store alias pre-escaped so we don't have to do this replacing every time this
	// 	// user sends a message
		
	// 	// escape JSON characters
	// 	boost::algorithm::replace_all(alias,"\\","\\\\");
	// 	boost::algorithm::replace_all(alias,"\"","\\\"");
		
	// 	// escape HTML characters
	// 	boost::algorithm::replace_all(alias,"&","&amp;");
	// 	boost::algorithm::replace_all(alias,"<","&lt;");
	// 	boost::algorithm::replace_all(alias,">","&gt;");
		
	// 	m_connections[client] = alias;
		
	// 	// set alias
	// 	send_to_all(serialize_state());
	// 	send_to_all(encode_message("server",response));
	// 	return;
	// }
	
	// // catch other slash commands
	// if (msg[0] == '/') {
	// 	client->send(encode_message("server","unrecognized command"));
	// 	return;
	// }
	
	// // create JSON message to send based on msg
	// send_to_all(encode_message(m_connections[client],msg));
}

// // {"type":"participants","value":[<participant>,...]}
// std::string socket_handler::serialize_state() {
// 	std::stringstream s;
	
// 	s << "{\"type\":\"participants\",\"value\":[";
	
// 	std::map<session_ptr,std::string>::iterator it;
	
// 	for (it = m_connections.begin(); it != m_connections.end(); it++) {
// 		s << "\"" << (*it).second << "\"";
// 		if (++it != m_connections.end()) {
// 			s << ",";
// 		}
// 		it--;
// 	}
	
// 	s << "]}";
	
// 	return s.str();
// }

// // {"type":"msg","sender":"<sender>","value":"<msg>" }
// std::string socket_handler::encode_message(std::string sender,std::string msg,bool escape) {
// 	std::stringstream s;
	
// 	// escape JSON characters
// 	boost::algorithm::replace_all(msg,"\\","\\\\");
// 	boost::algorithm::replace_all(msg,"\"","\\\"");
	
// 	// escape HTML characters
// 	if (escape) {
// 		boost::algorithm::replace_all(msg,"&","&amp;");
// 		boost::algorithm::replace_all(msg,"<","&lt;");
// 		boost::algorithm::replace_all(msg,">","&gt;");
// 	}
	
// 	s << "{\"type\":\"msg\",\"sender\":\"" << sender 
// 	  << "\",\"value\":\"" << msg << "\"}";
	
// 	return s.str();
// }

std::string socket_handler::get_con_id(session_ptr s) {
	std::stringstream endpoint;
	endpoint << s->socket().remote_endpoint();
	return endpoint.str();
}

void socket_handler::send_to_all(std::string data) {
	std::map<session_ptr,std::string>::iterator it;
	for (it = m_connections.begin(); it != m_connections.end(); it++) {
		(*it).first->send(data);
	}
};

void socket_handler::send_to_all_but_one(std::string data, session_ptr one) {
	std::map<session_ptr,std::string>::iterator it;
	for (it = m_connections.begin(); it != m_connections.end(); it++) {
		if((*it).first != one) {
			(*it).first->send(data);
		}
	}    
};
