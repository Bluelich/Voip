//
//  Benchmark.m
//  BLImageCompress
//
//  Created by Bluelich on 12/07/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
//

#import "Benchmark.h"

#ifdef DEBUG
    extern uint64_t  dispatch_benchmark(size_t count, dispatch_block_t block);
#endif

@implementation Benchmark
+(void)benchmarkWithTaskName:(NSString *)taskName
                executeCount:(NSInteger)executeCount
                        task:(dispatch_block_t)task
                  completion:(void (^)(NSString * _Nullable taskName, uint64_t nanoseconds))completion
{
#ifdef DEBUG
    if (!task) {
        !completion ?: completion(taskName,0);
        return;
    }
    uint64_t avgRunTime = dispatch_benchmark(executeCount, ^{
        @autoreleasepool {
            task();
        }
    });
    if (!completion) {
        NSLog(@"%@ 平均时间:%llu ns  %lfs",taskName,avgRunTime,avgRunTime / pow(10,9));
        return;
    }
    completion(taskName,avgRunTime);
#endif
}
@end
