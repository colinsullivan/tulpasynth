//
//  SocketHandler.h
//  tulpasynth
//
//  Created by Colin Sullivan on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "WebSocket.h"

//#import "SocketIO.h"

//#import "SRWebSocket.h"

#import "GCDAsyncSocket.h"

#define USE_SECURE_CONNECTION 0
#define ENABLE_BACKGROUNDING  1

#if USE_SECURE_CONNECTION
#define HOST @"128.12.158.62"
#define PORT 6666
#else
#define HOST @"128.12.158.62"
#define PORT 6666
#endif


@interface SocketHandler : NSObject <UIApplicationDelegate>

- (id) init;

@property (strong, nonatomic) GCDAsyncSocket* socket;

//- (void) socketIODidConnect:(SocketIO *)socket;
//- (void) socketIODidDisconnect:(SocketIO *)socket;
//- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet;
//- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet;
//- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet;
//- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet;
//- (void) socketIOHandshakeFailed:(SocketIO *)socket;

//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message;
//- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
//- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
//- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end
