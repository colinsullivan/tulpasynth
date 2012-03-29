/**
 *  @file       SocketHandler.mm
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2012 Colin Sullivan
 *              Licensed under the GPLv3 license.
 **/

#include <time.h>
#include <xlocale.h>

#import "SocketHandler.h"
#import "tulpaViewController.h"

@implementation SocketHandler

@synthesize socket, controller, timeSyncMessages, timeOffset;

- (id) initWithController:(tulpaViewController*)theController {
    if (self = [super init]) {

        self.controller = theController;
        self.timeSyncMessages = [[NSMutableArray alloc] init];

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
//            NSLog(@"Sending message: %@", message);
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
        
//        NSLog(@"creating model %d", [[[data valueForKey:@"attributes"] valueForKey:@"id"] intValue]);

        // create corresponding model
        Model* m = [[NSClassFromString([data valueForKey:@"class"]) alloc] initWithController:self.controller withAttributes:[data valueForKey:@"attributes"]];
//        // if model is not initialized, initialize
//        if (!m.initialized) {
//            m.initialized = true;
//        }
    }
    else if ([method isEqualToString:@"update"]) {
//        self.controller.paused = true;
        // Get model by id and set attributes
        NSNumber* modelId = [[data valueForKey:@"attributes"] valueForKey:@"id"];
        Model* m = [[Model Instances] getById:modelId];
        if (!m) {
//            NSLog(@"Model %d not found!", [modelId intValue]);
            return;
        }

        [m deserialize:[data valueForKey:@"attributes"]];
    }
    else if([method isEqualToString:@"unpause"]) {
//        self.controller.paused = false;
    }
    else if([method isEqualToString:@"time_sync"]) {
//        // store time received back to client
//        [data setValue:[[Model class] stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0.0]] forKey:@"time_received_back"];
//        
//        // store timesync message
        [self.timeSyncMessages addObject:data];
        if ([self.timeSyncMessages count] < 10) {
            // go again until we've got 10.
//            [NSThread sleepForTimeInterval:0.5];
            [self sendTimeSyncMessage];
        }
//        else {
//            // done, determine time offset
////            [self determineTimeOffset];
//        }
        
    }
    else {
        NSLog(@"Unrecognized method: %@", method);
    }
}

- (void) sendTimeSyncMessage {
    // send current time
    NSMutableDictionary* message = [NSDictionary dictionaryWithKeysAndObjects:
                                    @"method", @"time_sync",
                                    @"time_sent", [[Model class] stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0.0]],
                                    nil];
    [self send:message];
}

- (void) determineTimeOffset {
    float timeDiffSum = 0.0;
    int timeDiffCount = 0;

    // for each time sync message
    for (NSDictionary* timeSyncMessage in self.timeSyncMessages) {
        float time_sent = [[timeSyncMessage valueForKey:@"time_sent"] floatValue];
        float time_received_back = [[timeSyncMessage valueForKey:@"time_received_back"] floatValue];
        float time_server_received = [[timeSyncMessage valueForKey:@"time_received"] floatValue];
        NSLog(@"time_received_back: %f", time_received_back);
        NSLog(@"time_server_received: %f", time_server_received);
        NSLog(@"time_sent: %f", time_sent);

        // time it took to get to server
        timeDiffSum += time_server_received - time_sent;
        timeDiffCount++;
        
        // time it took to get back from server
//        timeDiffSum += time_received_back - time_server_received;
//        timeDiffCount++;
    }
    
    self.timeOffset = (timeDiffSum / ((float)timeDiffCount));
    
    NSLog(@"self.timeOffset: %f", self.timeOffset);
}

- (void) synchronizeModel:(Model*)aModel {

//    NSLog(@"syncronizeModel");
    
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
    
    [self sendTimeSyncMessage];
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", [error localizedDescription]);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"didCloseWithCode: %@\n\treason:%@\n\twasClean:%@", code, reason, wasClean);
}
@end
