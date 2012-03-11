//
//  SocketHandler.m
//  tulpasynth
//
//  Created by Colin Sullivan on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <time.h>
#include <xlocale.h>

#import "SocketHandler.h"
#import "tulpaViewController.h"

@implementation SocketHandler

@synthesize socket, controller;

- (id) initWithController:(tulpaViewController*)theController {
    if (self = [super init]) {

        self.controller = theController;

        NSString* SERVER_IP = [[NSUserDefaults standardUserDefaults] stringForKey:@"server_ip"];
        NSString* SERVER_PORT = [[NSUserDefaults standardUserDefaults] stringForKey:@"server_port"];
        NSString* SERVER_URL = [NSString stringWithFormat:@"ws://%@:%@", SERVER_IP, SERVER_PORT];
        
        self.socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL]]];
        self.socket.delegate = self;
        [self.socket open];
    }
    
    return self;
}

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


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSString *)message {
    NSError* error = nil;

//    NSLog(@"didReceiveMessage - parsing...");
    NSMutableDictionary* data = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"An error occurred while parsing response from server: %@", [error localizedDescription]);
        exit(-1);
    }
//    NSLog(@"didReceiveMessage: %@", data);

    NSString* method = [data valueForKey:@"method"];
    
    if ([method isEqualToString:@"response_id"]) {        
        // Get model that is currently waiting for an id
        Model* m = [self.controller.waitingForIds objectAtIndex:0];
        
        // remove from queue
        [self.controller.waitingForIds removeObjectAtIndex:0];
        
        // finish initializing model    
        m.id = [NSNumber numberWithInt:[[data valueForKey:@"id"] intValue]];
        m.initialized = true;
        
        // pause rendering
//        self.controller.paused = true;

        // send create message to other clients
        NSMutableDictionary* createMessage = [NSMutableDictionary dictionaryWithKeysAndObjects:
                                              @"method", @"create",
//                                              @"time", [NSString stringWithFormat:@"%f", [[NSDate dateWithTimeIntervalSinceNow:0.0f] timeIntervalSince1970]],
                                              @"attributes", [m serialize],
                                              @"class", NSStringFromClass([m class]), nil];
        [self send:createMessage];
    }
    else if ([method isEqualToString:@"create"]) {
        // pause rendering
//        self.controller.paused = true;

        // create corresponding model
        Model* m = [[NSClassFromString([data valueForKey:@"class"]) alloc] initWithController:self.controller withAttributes:[data valueForKey:@"attributes"]];
    }
    else if ([method isEqualToString:@"update"]) {
//        self.controller.paused = true;
        // Get model by id and set attributes
        NSNumber* modelId = [[data valueForKey:@"attributes"] valueForKey:@"id"];
        Model* m = [[Model Instances] getById:modelId];
        if (!m) {
            NSLog(@"Model not found!");
            exit(-1);
        }

        [m deserialize:[data valueForKey:@"attributes"]];
    }
    else if([method isEqualToString:@"unpause"]) {
//        self.controller.paused = false;
    }
    else {
        NSLog(@"Unrecognized method: %@", method);
    }
}

- (void) synchronizeModel:(Model*)aModel {

    if (aModel.nosync) {
        return;
    }

//    self.controller.paused = true;
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
