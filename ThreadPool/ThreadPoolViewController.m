//
//  ThreadPoolViewController.m
//  ThreadPool
//
//  Created by Kelp on 12/7/22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThreadPoolViewController.h"

@interface ThreadPoolViewController ()

@end

@implementation ThreadPoolViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)push:(id)sender
{
    ThreadPool *pool = [ThreadPool new];
    pool.maxThreadNumber = 2;
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(threadExecuteCode)
                                                 object:nil];
    thread.name = @"Thread A";
    [pool pushThread:thread];
    
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(threadExecuteCode)
                                       object:nil];
    thread.name = @"Thread B";
    [pool pushThread:thread];
    
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(threadExecuteCode)
                                       object:nil];
    thread.name = @"Thread C";
    [pool pushThread:thread];
    
    thread = [[NSThread alloc] initWithTarget:self
                                     selector:@selector(threadExecuteCode)
                                       object:nil];
    thread.name = @"Thread D";
    [pool pushThread:thread];
}

- (void)threadExecuteCode
{
    for (int index = 0; index < 10; index++) {
        NSLog(@"%@: %i", [NSThread currentThread].name, index);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
