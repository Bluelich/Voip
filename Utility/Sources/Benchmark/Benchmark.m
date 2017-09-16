//
//  Benchmark.m
//  BLImageCompress
//
//  Created by zhouqiang on 12/07/2017.
//  Copyright © 2017 zhouqiang. All rights reserved.
//

#import "Benchmark.h"

extern uint64_t  dispatch_benchmark(size_t count, void (^block)(void));

@implementation Benchmark
+(void)benchmarkWithTaskName:(NSString *)taskName
                executeCount:(NSInteger)executeCount
                        task:(void (^)(void))task
                  completion:(void (^)(NSString * _Nullable taskName, uint64_t nanoseconds))completion
{
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
}
@end
