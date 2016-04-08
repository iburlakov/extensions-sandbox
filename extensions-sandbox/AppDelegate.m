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

NSString *pathToMonitor = @"/Users/iburlakov/experiments";



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    
    if (![defaults boolForKey:@"isImageReseted"]) {
        NSLog(@"Resetting folder image for %@", pathToMonitor);
        [[NSWorkspace sharedWorkspace] setIcon:[NSImage imageNamed:@"extensions-folder-icon"]
                                       forFile:pathToMonitor
                                       options:0];
        [defaults setBool:YES forKey:@"isImageReseted"];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass
                                                                        andEventID:kAEGetURL];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)handleGetURLEvent:(NSAppleEventDescriptor *)event
           withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSString* url = [[event paramDescriptorForKeyword:keyDirectObject]
                     stringValue];
    
    
    [[SchemaChannel channel] publish:url];
}

@end
