//
//  SchemaChannel.m
//  extensions-sandbox
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import "SchemaChannel.h"

@implementation SchemaChannel

- (id)initInt {
    self = [super init];
    
    subscriptions = [[NSMutableArray alloc]init];
    
    return self;
}

SchemaChannel *_channel;
+ (SchemaChannel *)channel {
    if (!_channel) {
        _channel = [[SchemaChannel alloc]initInt];
    }
    
    return _channel;
}

- (void)subscribe:(void (^)(NSString *))block {
    [subscriptions addObject:block];
}



- (void)publish:(NSString *)message {
    NSString *schema = @"EXTSANDBOX://"; // TODO: move to shared code

    NSString *decodedMessage = [[message substringFromIndex:schema.length] stringByRemovingPercentEncoding];

    
    for (void (^ block)(NSString *arg) in subscriptions) {
        if (block) {
            block(decodedMessage);
        }
    }
}

@end
