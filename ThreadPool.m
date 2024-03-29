//
//  ThreadPool.m
//  ThreadPool
//
//  Created by Kelp on 12/7/22.
//  Copyright (c) 2012 Phate. All rights reserved.
//

#import "ThreadPool.h"


#pragma mark - ThreadPool
@implementation ThreadPool

#pragma mark - Property
@synthesize maxThreadNumber = _maxThreadNumber;
@synthesize delegate = _delegate;
- (BOOL)isPoolCleared
{
    return [_poolExecute count] + [_poolQueue count] == 0;
}


static ThreadPool *instance;

#pragma mark - Initialize
+ (id)sharedInstance
{
    @synchronized (instance) {
        if (instance == nil) {
            instance = [ThreadPool new];
        }
        
        return instance;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _poolQueue = [NSMutableArray new];
        _poolExecute = [NSMutableArray new];
        _maxThreadNumber = 1;
    }
    return self;
}

#pragma mark push a thread
- (void)pushThread:(NSThread *)thread
{
    [self pushThread:thread threadPoolType:ThreadPoolQueue];
}
- (void)pushThread:(NSThread *)thread threadPoolType:(ThreadPoolType)threadPoolType
{
    switch (threadPoolType) {
        case ThreadPoolCancelThis:
            // cancel the new thread
            if ([_poolExecute count] == 0 && [_poolQueue count] == 0) {
                [_poolQueue addObject:thread];
            }
            break;
        case ThreadPoolCancelBefore:
            // cancel threads in pool and run the new thread
            [_poolQueue removeAllObjects];
            [self cancelAllthreadsInExecutePool];
            [_poolQueue addObject:thread];
            break;
        case ThreadPoolQueue:
        default:
            [_poolQueue addObject:thread];
            break;
    }
    
    if (_timer == nil) {
        _timer = [[NSTimer alloc] initWithFireDate:[NSDate date]
                                          interval:1
                                            target:self
                                          selector:@selector(checkThread:)
                                          userInfo:nil
                                           repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode]; 
    }
}

#pragma mark thread managementor
- (void)checkThread:(NSTimer *)timer
{
    // check execute pool
    NSMutableIndexSet *indexSet = [NSMutableIndexSet new];
    for (int index = 0; index < [_poolExecute count]; index++) {
        NSThread *thread = [_poolExecute objectAtIndex:index];
        if (thread.isFinished) {
            [indexSet addIndex:index];
        }
    }
    [_poolExecute removeObjectsAtIndexes:indexSet];
    
    // execute a new thread
    while ([_poolExecute count] < _maxThreadNumber && [_poolQueue count] > 0) {
        NSThread *thread = [_poolQueue objectAtIndex:0];
        [_poolExecute addObject:thread];
        [_poolQueue removeObjectAtIndex:0];
        [thread start];
    }
    
    // turn off timer
    if ([_poolQueue count] + [_poolExecute count] == 0) {
        [_timer invalidate];
        _timer = nil;
        if (_delegate) {
            [(NSObject *)_delegate performSelectorOnMainThread:@selector(poolCleared:)
                                                    withObject:self
                                                 waitUntilDone:false];
        }
    }
}

#pragma mark cancel thread
- (void)cancelAllthreadsInExecutePool
{
    for (NSThread *thread in _poolExecute) {
        [thread cancel];
    }
}
- (void)cancelAllThreads
{
    [_poolQueue removeAllObjects];
    [self cancelAllthreadsInExecutePool];
}

@end
