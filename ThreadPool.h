//
//  ThreadPool 1.0
//
//  Created by Kelp on 12/7/22.
//  Copyright (c) 2012 Phate. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ThreadPool;

#pragma mark - Enums
enum {
    ThreadPoolQueue = 0,
    ThreadPoolCancelBefore,
    ThreadPoolCancelThis
};
typedef NSUInteger ThreadPoolType;


#pragma mark - Protocol
@protocol ThreadPoolDelegate
- (void)poolCleared:(ThreadPool *)threadPool;
@end


#pragma mark - ThreadPool
@interface ThreadPool : NSObject {
    NSMutableArray *_poolQueue;
    NSMutableArray *_poolExecute;
    NSTimer *_timer;
}

@property int maxThreadNumber;
@property (strong) id<ThreadPoolDelegate> delegate;
@property (readonly) BOOL isPoolCleared;

+ (id)sharedInstance;
- (void)pushThread:(NSThread *)thread;
- (void)pushThread:(NSThread *)thread threadPoolType:(ThreadPoolType)threadPoolType;
 
- (void)cancelAllthreadsInExecutePool;
- (void)cancelAllThreads;

@end
