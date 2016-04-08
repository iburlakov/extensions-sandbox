//
//  SchemaChannel.h
//  extensions-sandbox
//
//  Created by Ivan Burlakov on 4/7/16.
//  Copyright © 2016 Ivan Burlakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchemaChannel : NSObject {
    NSMutableArray *subscriptions;
}

+ (SchemaChannel *)channel;

- (void)subscribe:(void(^)(NSString *arg))block;
- (void)publish:(NSString *)message;

@end
