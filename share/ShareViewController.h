//
//  ShareViewController.h
//  share
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ShareViewController : NSViewController {
    
    __weak IBOutlet NSTextField *dataToSend;
    __weak IBOutlet NSButton *sendButton;
}

@end
