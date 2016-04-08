//
//  AppDelegate.m
//  extensions-sandbox
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import "AppDelegate.h"
#import "SchemaChannel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

-(void)applicationWillFinishLaunching:(NSNotification *)notification {
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self
                                                       andSelector:@selector(handleGetURLEvent:withReplyEvent:)
                                                     forEventClass:kInternetEventClass
                                                        andEventID:kAEGetURL];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass
                                                                        andEventID:kAEGetURL];
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event
           withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject]
                     stringValue];
    
    
    [[SchemaChannel channel] publish:url];
}

@end
