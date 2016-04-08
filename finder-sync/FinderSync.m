//
//  FinderSync.m
//  finder-sync
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import "FinderSync.h"

@interface FinderSync ()

@property NSURL *myFolderURL;

@end

@implementation FinderSync

// TODO: should be shared code
NSString *pathToMonitor = @"/Users/iburlakov/experiments";

- (instancetype)init {
    self = [super init];

    NSLog(@"%s launched from %@ ; compiled at %s", __PRETTY_FUNCTION__, [[NSBundle mainBundle] bundlePath], __TIME__);

    // Set up the directory we are syncing.
    self.myFolderURL = [NSURL fileURLWithPath:pathToMonitor];
    [FIFinderSyncController defaultController].directoryURLs = [NSSet setWithObject:self.myFolderURL];

    NSLog(@"started monitoring %@", pathToMonitor);
    
    // Set up images for our badge identifiers. For demonstration purposes, this uses off-the-shelf images.
    //[[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameColorPanel] label:@"Status One" forBadgeIdentifier:@"One"];
    //[[FIFinderSyncController defaultController] setBadgeImage:[NSImage imageNamed: NSImageNameCaution] label:@"Status Two" forBadgeIdentifier:@"Two"];
    
    return self;
}


#pragma mark - Primary Finder Sync protocol methods

- (void)beginObservingDirectoryAtURL:(NSURL *)url {
    // The user is now seeing the container's contents.
    // If they see it in more than one view at a time, we're only told once.
    NSLog(@"beginObservingDirectoryAtURL:%@", url.filePathURL);
}


- (void)endObservingDirectoryAtURL:(NSURL *)url {
    // The user is no longer seeing the container's contents.
    NSLog(@"endObservingDirectoryAtURL:%@", url.filePathURL);
}

- (void)requestBadgeIdentifierForURL:(NSURL *)url {
    NSLog(@"requestBadgeIdentifierForURL:%@", url.filePathURL);
    
    // For demonstration purposes, this picks one of our two badges, or no badge at all, based on the filename.
    NSInteger whichBadge = [url.filePathURL hash] % 3;
    NSString* badgeIdentifier = @[@"", @"One", @"Two"][whichBadge];
    [[FIFinderSyncController defaultController] setBadgeIdentifier:badgeIdentifier forURL:url];
}

#pragma mark - Menu and toolbar item support

- (NSString *)toolbarItemName {
    return @"finder-sync";
}

- (NSString *)toolbarItemToolTip {
    return @"finder-sync: Click the toolbar item for a menu.";
}

- (NSImage *)toolbarItemImage {
    return [NSImage imageNamed:@"toolbar-icon.png"];
}

//- (void)sampleAction {
//    NSAlert *alert = [[NSAlert alloc] init];
//    alert.messageText = @"alert";
//    [alert runModal];
//}

- (NSMenu *)menuForMenuKind:(FIMenuKind)whichMenu {
    NSLog(@"menuForMenuKind");
    // toolbar
    if (FIMenuKindToolbarItemMenu == whichMenu) {
        NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
        
        // do not support multi-select
        NSArray* selectedItems = [[FIFinderSyncController defaultController] selectedItemURLs];
        
        if (selectedItems.count > 0) {
            NSURL *url = selectedItems[0];
            NSString *path = url.filePathURL.path;
            
            if ([path hasPrefix:pathToMonitor]) {
                [menu addItemWithTitle:@"sample menu item" action:@selector(sampleAction:) keyEquivalent:@""];

            
                return  menu;
            }
            
        }

        // in case of no selection, multiselect, non-monitored file/folder or not running client
        NSMenuItem *sub = [[NSMenuItem alloc] initWithTitle:@"No actions to perform" action:nil keyEquivalent:@""];
        [sub setEnabled:NO];
        [menu addItem:sub];
        
        return menu;
    }

    
    // Produce a menu for the extension.
    NSMenu *menu = [[NSMenu alloc] initWithTitle:@""];
    [menu addItemWithTitle:@"Example Menu Item" action:@selector(sampleAction:) keyEquivalent:@""];

    return menu;
}

- (IBAction)sampleAction:(id)sender {
    NSURL* target = [[FIFinderSyncController defaultController] targetedURL];
    NSArray* items = [[FIFinderSyncController defaultController] selectedItemURLs];

    NSLog(@"sampleAction: menu item: %@, target = %@, items = ", [sender title], [target filePathURL]);
    [items enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"    %@", [obj filePathURL]);
    }];
}

@end

