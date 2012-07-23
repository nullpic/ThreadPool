#ThreadPool 1.0


Kelp http://kelp.phate.org/ <br/>
MIT License


Thread Pool is a thread queue.<br/>
You could push threads to ThreadPool, and then it will process the thread.


```objective-c
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
```
```objective-c
- (void)threadExecuteCode
{
    for (int index = 0; index < 10; index++) {
        NSLog(@"%@: %i", [NSThread currentThread].name, index);
    }
}
```
