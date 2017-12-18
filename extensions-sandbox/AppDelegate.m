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
    
    // elect extensions if not elected yet
    [self electBoth];
    
    // set custom icon for monitored folder
    [self setCustomImage:@"extensions-folder-icon" forPath:pathToMonitor];
}


- (void)setCustomImage:(NSString *)imageName forPath:(NSString *)path {
    [[NSWorkspace sharedWorkspace] setIcon:[NSImage imageNamed:imageName]
                                   forFile:path
                                   options:0];
}

- (void)electBoth {
    execute(@"/usr/bin/pluginkit",  @[@"-m", @"-e", @"use", @"-i", @"extensions-sandbox.finder-sync"]);
    execute(@"/usr/bin/pluginkit",  @[@"-m", @"-e", @"use", @"-i", @"extensions-sandbox.share"]);
}

- (void)ignoreFinderSync {
    execute(@"/usr/bin/pluginkit",  @[@"-m", @"-e", @"ignore", @"-i", @"extensions-sandbox.finder-sync"]);
}

int execute(NSString *command, NSArray *args) {
    NSTask *taskToExec = [NSTask launchedTaskWithLaunchPath:command arguments:args];
    [taskToExec waitUntilExit];
    return taskToExec.terminationStatus;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[NSAppleEventManager sharedAppleEventManager] removeEventHandlerForEventClass:kInternetEventClass
                                                                        andEventID:kAEGetURL];
    [self ignoreFinderSync];
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
