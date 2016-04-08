//
//  ViewController.m
//  extensions-sandbox
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import "ViewController.h"
#import "SchemaChannel.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[SchemaChannel channel] subscribe:^(NSString *arg) {
        [logTextField setStringValue:[logTextField.stringValue stringByAppendingString:[NSString stringWithFormat:@"\n%@", arg]]];
    }];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
