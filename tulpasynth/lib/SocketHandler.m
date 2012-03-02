//
//  SocketHandler.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SocketHandler.h"


@implementation SocketHandler

@synthesize socket;

- (id) init {
    if (self = [super init]) {
        
        
        dispatch_queue_t socketQueue = dispatch_queue_create("socketQueue", NULL);
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:socketQueue];
        
        #if USE_SECURE_CONNECTION
        {
            NSString *host = HOST;
            uint16_t port = PORT;
            
            NSLog(@"Connecting to \"%@\" on port %hu...", host, port);
            
            NSError *error = nil;
            if (![asyncSocket connectToHost:host onPort:port error:&error])
            {
                NSLog(@"Error connecting: %@", error);
            }
        }
#else
        {
            NSString *host = HOST;
            uint16_t port = PORT;
            
            NSLog(@"Connecting to \"%@\" on port %hu...", host, port);
            
            NSError *error = nil;
            if (![self.socket connectToHost:host onPort:port error:&error])
            {
                NSLog(@"Error connecting: %@", error);
            }
            
            // You can also specify an optional connect timeout.
            
            //	NSError *error = nil;
            //	if (![asyncSocket connectToHost:host onPort:80 withTimeout:5.0 error:&error])
            //	{
            //		DDLogError(@"Error connecting: %@", error);
            //	}
            
        }
#endif

        
        
//        WebSocketConnectConfig* config = [WebSocketConnectConfig configWithURLString:@"ws://128.12.158.62:6666/" origin:nil protocols:nil tlsSettings:nil headers:nil verifySecurityKey:YES extensions:nil];
//        config.closeTimeout = 15.0;
//
//        self.socket = [WebSocket webSocketWithConfig:config delegate:self];
        
//        self.socket = [[SocketIO alloc] initWithDelegate:self];
//        self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://128.12.158.62:6666/"]] ];
//        self.socket.delegate = self;
        
//        [self.socket open];
        
//        [self.socket connectToHost:@"128.12.158.62" onPort:6666 secure:false];
        
    }
    
    return self;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
	NSLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    	
    //	NSLog(@"localHost :%@ port:%hu", [sock localHost], [sock localPort]);
	
#if USE_SECURE_CONNECTION
	{
		// Connected to secure server (HTTPS)
        
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{	
			// Backgrounding doesn't seem to be supported on the simulator yet
            
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket])
					NSLog(@"Enabled backgrounding on socket");
				else
					NSLog(@"Enabling backgrounding failed!");
			}];
		}	
#endif
        
		// Configure SSL/TLS settings
		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
        
		// If you simply want to ensure that the remote host's certificate is valid,
		// then you can use an empty dictionary.
        
		// If you know the name of the remote host, then you should specify the name here.
		// 
		// NOTE:
		// You should understand the security implications if you do not specify the peer name.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
        
		[settings setObject:HOST
					 forKey:(NSString *)kCFStreamSSLPeerName];
        
		// To connect to a test server, with a self-signed certificate, use settings similar to this:
        
        //	// Allow expired certificates
        //	[settings setObject:[NSNumber numberWithBool:YES]
        //				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
        //	
        //	// Allow self-signed certificates
        //	[settings setObject:[NSNumber numberWithBool:YES]
        //				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
        //	
        //	// In fact, don't even validate the certificate chain
        //	[settings setObject:[NSNumber numberWithBool:NO]
        //				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
        
		NSLog(@"Starting TLS with settings:\n%@", settings);
        
		[sock startTLS:settings];
        
		// You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
		// Again, you should understand the security implications of doing so.
		// Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
        
	}
#else
	{
		// Connected to normal server (HTTP)
		
#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
		{
			// Backgrounding doesn't seem to be supported on the simulator yet
            
			[sock performBlock:^{
				if ([sock enableBackgroundingOnSocket]) {
					NSLog(@"Enabled backgrounding on socket");
                    
                    NSString* message = @"Hello there";
                    [sock writeData:[message dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:1];
                }
				else
					NSLog(@"Enabling backgrounding failed!");
			}];
		}
#endif
	}
#endif
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
	NSLog(@"socketDidSecure:%p", sock);
    
	NSString *requestStr = [NSString stringWithFormat:@"GET / HTTP/1.1\r\nHost: %@\r\n\r\n", HOST];
	NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
	[sock writeData:requestData withTimeout:-1 tag:0];
	[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	NSLog(@"socket:%p didWriteDataWithTag:%d", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSLog(@"socket:%p didReadData:withTag:%d", sock, tag);
    
	NSString *httpResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
	NSLog(@"HTTP Response:\n%@", httpResponse);
    
	[httpResponse release];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
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

//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message {
//    NSLog(@"didReceiveMessage");
//}
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
//    NSLog(@"didOpen");
//}
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
//    NSLog(@"didFailWithError: %@", [error localizedDescription]);
//}
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
//    NSLog(@"didCloseWithCode: %@\n\treason:%@\n\twasClean:%@", code, reason, wasClean);
//}


@end
