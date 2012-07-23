//
//  ThreadPool 1.0
//
//  Created by Kelp on 12/7/22.
//  Copyright (c) 2012 Phate. MIT License.
//

#import <Foundation/Foundation.h>

#pragma mark - Enums
enum {
    ThreadPoolQueue = 0,
    ThreadPoolCancelBefore,
    ThreadPoolCancelNew
};
typedef NSUInteger ThreadPoolType;


#pragma mark - ThreadPool
@interface ThreadPool : NSObject {
    NSMutableArray *_poolQueue;
    NSMutableArray *_poolExecute;
    NSTimer *_timer;
}

@property ThreadPoolType poolType;
@property int maxThreadNumber;

+ (id)sharedInstance;
- (void)pushThread:(NSThread *)thread;

@end
