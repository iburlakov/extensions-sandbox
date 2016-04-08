//
//  ShareViewController.m
//  share
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

- (NSString *)nibName {
    return @"ShareViewController";
}

- (void)loadView {
    [super loadView];
    
    // Insert code here to customize the view
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;

    
    for (NSItemProvider *provider in item.attachments) {
        [provider loadItemForTypeIdentifier:(NSString *)kUTTypeURL
                                    options:nil
                          completionHandler:^(NSURL *url, NSError *error) {
                              if (dataToSend.stringValue.length > 0) {
                                  [dataToSend setStringValue:[dataToSend.stringValue stringByAppendingString:[NSString stringWithFormat:@"\n%@", url.path]]];
                              } else {
                                  [dataToSend setStringValue:url.path];
                              }}];
    }
}

- (IBAction)send:(id)sender {
    
    NSString *schema = @"EXTSANDBOX"; // TODO: move to shared code
    
    
   
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", schema, [url.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]]]];


    //NSLog(@"Sending: %@", url);
    
    [self.extensionContext openURL:url completionHandler:^(BOOL success) {
        if (success){
            NSLog(@"OK");
        } else { NSLog(@"FAILED");}
        
        NSExtensionItem *outputItem = [[NSExtensionItem alloc] init];
        
        NSArray *outputItems = @[outputItem];
        [self.extensionContext completeRequestReturningItems:outputItems completionHandler:nil];
    }];
    

    
    
    //BOOL res = ([[NSWorkspace sharedWorkspace] openURL:url]);
   //    } else {
//
//
//       [dataToSend setStringValue:[dataToSend.stringValue stringByAppendingString:@"FAILED TO SEND DATA"]];
//    }
}

- (IBAction)cancel:(id)sender {
    NSError *cancelError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil];
    [self.extensionContext cancelRequestWithError:cancelError];
}

@end

