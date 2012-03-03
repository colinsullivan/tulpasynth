//
//  SocketHandler.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocketHandler.h"
#import "tulpaViewController.h"

@implementation SocketHandler

@synthesize socket, controller;

- (id) initWithController:(tulpaViewController*)theController {
    if (self = [super init]) {

        self.controller = theController;

        self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://128.12.158.62:6666"]]];
        self.socket.delegate = self;
        [self.socket open];
//        self.socketQueue = dispatch_queue_create("socketQueue", NULL);
//        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
//        self.socket = [[AsyncSocket alloc] initWithDelegate:self];
        
//        #if USE_SECURE_CONNECTION
//        {
//            NSString *host = HOST;
//            uint16_t port = PORT;
//            
//            NSLog(@"Connecting to \"%@\" on port %hu...", host, port);
//            
//            NSError *error = nil;
//            if (![asyncSocket connectToHost:host onPort:port error:&error])
//            {
//                NSLog(@"Error connecting: %@", error);
//            }
//        }
//#else
//        {
//            NSString *host = HOST;
//            uint16_t port = PORT;
//            
//            NSLog(@"Connecting to \"%@\" on port %hu...", host, port);
//            
//            NSError *error = nil;
//            if (![self.socket connectToHost:host onPort:port error:&error])
//            {
//                NSLog(@"Error connecting: %@", error);
//            }
//            
//            // You can also specify an optional connect timeout.
//            
//            //	NSError *error = nil;
//            //	if (![asyncSocket connectToHost:host onPort:80 withTimeout:5.0 error:&error])
//            //	{
//            //		DDLogError(@"Error connecting: %@", error);
//            //	}
//            
//        }
//#endif
//
//        
//        
////        WebSocketConnectConfig* config = [WebSocketConnectConfig configWithURLString:@"ws://128.12.158.62:6666/" origin:nil protocols:nil tlsSettings:nil headers:nil verifySecurityKey:YES extensions:nil];
////        config.closeTimeout = 15.0;
////
////        self.socket = [WebSocket webSocketWithConfig:config delegate:self];
//        
////        self.socket = [[SocketIO alloc] initWithDelegate:self];
////        self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://128.12.158.62:6666/"]] ];
////        self.socket.delegate = self;
//        
////        [self.socket open];
//        
////        [self.socket connectToHost:@"128.12.158.62" onPort:6666 secure:false];
//        
    }
    
    return self;
}

///**
// * In the event of an error, the socket is closed.
// * You may call "unreadData" during this call-back to get the last bit of data off the socket.
// * When connecting, this delegate method may be called
// * before"onSocket:didAcceptNewSocket:" or "onSocket:didConnectToHost:".
// **/
//- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
//    NSLog(@"willDisconnectWithError");
//}
//
///**
// * Called when a socket disconnects with or without error.  If you want to release a socket after it disconnects,
// * do so here. It is not safe to do that during "onSocket:willDisconnectWithError:".
// * 
// * If you call the disconnect method, and the socket wasn't already disconnected,
// * this delegate method will be called before the disconnect method returns.
// **/
//- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
//    NSLog(@"connecting");
//}
//
///**
// * Called when a socket accepts a connection.  Another socket is spawned to handle it. The new socket will have
// * the same delegate and will call "onSocket:didConnectToHost:port:".
// **/
//- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket {
//}
//
///**
// * Called when a new socket is spawned to handle a connection.  This method should return the run-loop of the
// * thread on which the new socket and its delegate should operate. If omitted, [NSRunLoop currentRunLoop] is used.
// **/
//- (NSRunLoop *)onSocket:(AsyncSocket *)sock wantsRunLoopForNewSocket:(AsyncSocket *)newSocket;
//
///**
// * Called when a socket is about to connect. This method should return YES to continue, or NO to abort.
// * If aborted, will result in AsyncSocketCanceledError.
// * 
// * If the connectToHost:onPort:error: method was called, the delegate will be able to access and configure the
// * CFReadStream and CFWriteStream as desired prior to connection.
// *
// * If the connectToAddress:error: method was called, the delegate will be able to access and configure the
// * CFSocket and CFSocketNativeHandle (BSD socket) as desired prior to connection. You will be able to access and
// * configure the CFReadStream and CFWriteStream in the onSocket:didConnectToHost:port: method.
// **/
//- (BOOL)onSocketWillConnect:(AsyncSocket *)sock;
//
///**
// * Called when a socket connects and is ready for reading and writing.
// * The host parameter will be an IP address, not a DNS name.
// **/
//- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
//
///**
// * Called when a socket has completed reading the requested data into memory.
// * Not called if there is an error.
// **/
//- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
//
///**
// * Called when a socket has read in data, but has not yet completed the read.
// * This would occur if using readToData: or readToLength: methods.
// * It may be used to for things such as updating progress bars.
// **/
//- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;
//
///**
// * Called when a socket has completed writing the requested data. Not called if there is an error.
// **/
//- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;
//
///**
// * Called when a socket has written some data, but has not yet completed the entire write.
// * It may be used to for things such as updating progress bars.
// **/
//- (void)onSocket:(AsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag;
//
///**
// * Called if a read operation has reached its timeout without completing.
// * This method allows you to optionally extend the timeout.
// * If you return a positive time interval (> 0) the read's timeout will be extended by the given amount.
// * If you don't implement this method, or return a non-positive time interval (<= 0) the read will timeout as usual.
// * 
// * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
// * The length parameter is the number of bytes that have been read so far for the read operation.
// * 
// * Note that this method may be called multiple times for a single read if you return positive numbers.
// **/
//- (NSTimeInterval)onSocket:(AsyncSocket *)sock
//  shouldTimeoutReadWithTag:(long)tag
//                   elapsed:(NSTimeInterval)elapsed
//                 bytesDone:(NSUInteger)length;
//
///**
// * Called if a write operation has reached its timeout without completing.
// * This method allows you to optionally extend the timeout.
// * If you return a positive time interval (> 0) the write's timeout will be extended by the given amount.
// * If you don't implement this method, or return a non-positive time interval (<= 0) the write will timeout as usual.
// * 
// * The elapsed parameter is the sum of the original timeout, plus any additions previously added via this method.
// * The length parameter is the number of bytes that have been written so far for the write operation.
// * 
// * Note that this method may be called multiple times for a single write if you return positive numbers.
// **/
//- (NSTimeInterval)onSocket:(AsyncSocket *)sock
// shouldTimeoutWriteWithTag:(long)tag
//                   elapsed:(NSTimeInterval)elapsed
//                 bytesDone:(NSUInteger)length;
//
///**
// * Called after the socket has successfully completed SSL/TLS negotiation.
// * This method is not called unless you use the provided startTLS method.
// * 
// * If a SSL/TLS negotiation fails (invalid certificate, etc) then the socket will immediately close,
// * and the onSocket:willDisconnectWithError: delegate method will be called with the specific SSL error code.
// **/
//- (void)onSocketDidSecure:(AsyncSocket *)sock;

//- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
//{
//	NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
//    	
//    //	NSLog(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
//	
//#if USE_SECURE_CONNECTION
//	{
//		// Connected to secure server (HTTPS)
//        
//#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
//		{	
//			// Backgrounding doesn't seem to be supported on the simulator yet
//            
//			[sock performBlock:^{
//				if ([sock enableBackgroundingOnSocket])
//					NSLog(@"Enabled backgrounding on socket");
//				else
//					NSLog(@"Enabling backgrounding failed!");
//			}];
//		}	
//#endif
//        
//		// Configure SSL/TLS settings
//		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
//        
//		// If you simply want to ensure that the remote host's certificate is valid,
//		// then you can use an empty dictionary.
//        
//		// If you know the name of the remote host, then you should specify the name here.
//		// 
//		// NOTE:
//		// You should understand the security implications if you do not specify the peer name.
//		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
//        
//		[settings setObject:HOST
//					 forKey:(NSString *)kCFStreamSSLPeerName];
//        
//		// To connect to a test server, with a self-signed certificate, use settings similar to this:
//        
//        //	// Allow expired certificates
//        //	[settings setObject:[NSNumber numberWithBool:YES]
//        //				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
//        //	
//        //	// Allow self-signed certificates
//        //	[settings setObject:[NSNumber numberWithBool:YES]
//        //				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
//        //	
//        //	// In fact, don't even validate the certificate chain
//        //	[settings setObject:[NSNumber numberWithBool:NO]
//        //				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
//        
//		NSLog(@"Starting TLS with settings:\n%@", settings);
//        
//		[sock startTLS:settings];
//        
//		// You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
//		// Again, you should understand the security implications of doing so.
//		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
//        
//	}
//#else
//	{
//		// Connected to normal server (HTTP)
//		
//#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
//		{
//			// Backgrounding doesn't seem to be supported on the simulator yet
//            
//			[sock performBlock:^{
//				if ([sock enableBackgroundingOnSocket]) {
//					NSLog(@"Enabled backgrounding on socket");                    
//                }
//				else
//					NSLog(@"Enabling backgrounding failed!");
//			}];
//		}
//#endif
//	}
//#endif
//}
//
//- (void)socketDidSecure:(GCDAsyncSocket *)sock
//{
//	NSLog(@"socketDidSecure:%p", sock);
//    
//	NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
//	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
//    
//	[sock writeData:requestData withTimeout:-1 tag:0];
//	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
//{
//	NSLog(@"socket:%p didWriteDataWithTag:%d", sock, tag);
//}
//
//- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
//{
//	NSLog(@"socket:%p didReadData:withTag:%d", sock, tag);
//    
//	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//	NSLog(@"HTTP Response:\n%@", httpResponse);
//    
//	[httpResponse release];
//}
//
//- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
//{
//	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
//}
//
- (void) send:(NSMutableDictionary*)message {
    NSData* serializedMessage = nil;
    NSError* error = nil;
    
    if ([NSJSONSerialization isValidJSONObject:message]) {
        serializedMessage = [NSJSONSerialization dataWithJSONObject:message options:0 error:&error];
        
        if (error) {
            NSLog(@"ERROR: While serializing: %@", [error localizedDescription]);
        }
        else {
//            [self.socket writeData:serializedMessage withTimeout:-1 tag:0];
            [self.socket send:serializedMessage];
        }
    }
    else {
        NSLog(@"ERROR: Invalid JSON");
        exit(-1);
    }
}


///**
// * Called when the web socket connects and is ready for reading and writing.
// **/
//- (void) didOpen
//{
//    NSLog(@"Socket is open for business.");
//}
//
///**
// * Called when the web socket closes. aError will be nil if it closes cleanly.
// **/
//- (void) didClose:(NSUInteger) aStatusCode message:(NSString*) aMessage error:(NSError*) aError
//{
//    NSLog(@"Oops. It closed.");
//}
//
///**
// * Called when the web socket receives an error. Such an error can result in the
// socket being closed.
// **/
//- (void) didReceiveError:(NSError*) aError
//{
//    NSLog(@"Oops. An error occurred: %@", [aError localizedDescription]);
//}
//
///**
// * Called when the web socket receives a message.
// **/
//- (void) didReceiveTextMessage:(NSString*) aMessage
//{
//    //Hooray! I got a message to print.
//    NSLog(@"Did receive message: %@", aMessage);
//}
//
///**
// * Called when the web socket receives a message.
// **/
//- (void) didReceiveBinaryMessage:(NSData*) aMessage
//{
//    //Hooray! I got a binary message.
//}
//
///**
// * Called when pong is sent... For keep-alive optimization.
// **/
//- (void) didSendPong:(NSData*) aMessage
//{
//    NSLog(@"Yay! Pong was sent!");
//}


//- (void) socketIODidConnect:(SocketIO *)socket {
//    NSLog(@"Socket connected");
//}
//- (void) socketIODidDisconnect:(SocketIO *)socket {
//    NSLog(@"Socket disconnected");
//}
//- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
//    NSLog(@"Socket message received");
//}
//- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
//    NSLog(@"JSON message received");
//}
//- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
//    NSLog(@"event received");
//}
//- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
//    NSLog(@"Message sent");
//}
//- (void) socketIOHandshakeFailed:(SocketIO *)socket {
//    NSLog(@"handshake failed");
//}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message {
    NSError* error = nil;

    NSLog(@"didReceiveMessage - parsing...");
    NSMutableDictionary* data = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"An error occurred while parsing response from server: %@", [error localizedDescription]);
        exit(-1);
    }
    NSLog(@"didReceiveMessage: %@", data);

    NSString* method = [data valueForKey:@"method"];
    
    if ([method isEqualToString:@"response_id"]) {
        // Get model that is currently waiting for an id
        Model* m = [self.controller.waitingForIds objectAtIndex:0];
        
        // remove from queue
        [self.controller.waitingForIds removeObjectAtIndex:0];
        
        // finish initializing model    
        m.id = [NSNumber numberWithInt:[[data valueForKey:@"id"] intValue]];
        m.initialized = true;

        // send create message to other clients
        NSMutableDictionary* createMessage = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                              @"method", @"create",
                                              @"attributes", [m serialize],
                                              @"class", NSStringFromClass([m class]), nil];
        [self send:createMessage];
    }
    else if ([method isEqualToString:@"create"]) {
        // create corresponding model
        Model* m = [[NSClassFromString([data valueForKey:@"class"]) alloc] initWithController:self.controller withAttributes:[data valueForKey:@"attributes"]];
    }
    else if ([method isEqualToString:@"update"]) {
        // Get model by id and set attributes
        NSNumber* modelId = [[data valueForKey:@"attributes"] valueForKey:@"id"];
        Model* m = [[Model Instances] getById:modelId];
        if (!m) {
            NSLog(@"Model not found!");
            exit(-1);
        }

        [m deserialize:[data valueForKey:@"attributes"]];
    }
}

- (void) synchronizeModel:(Model*)aModel {
    NSMutableDictionary* message = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                    @"method", @"update",
                                    @"attributes", [aModel serialize],
                                    @"class", NSStringFromClass([aModel class]), nil];
                                    
    [self send:message];
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"didOpen");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", [error localizedDescription]);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode: %@\n\treason:%@\n\twasClean:%@", code, reason, wasClean);
}


@end
