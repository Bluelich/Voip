//
//  Benchmark.h
//  BLImageCompress
//
//  Created by Bluelich on 12/07/2017.
//  Copyright © 2017 Bluelich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Benchmark : NSObject
/**
 主线程,同步,执行benchmark(默认执行次数为1)
 
 @param taskName        任务描述
 @param executeCount    执行次数
 @param task            要执行的代码
 @param completion      结束后回调的block(taskName:任务描述 nanoseconds:代码的平均执行时间[纳秒])
 */
+(void)benchmarkWithTaskName:(NSString *)taskName
                executeCount:(NSInteger)executeCount
                        task:(dispatch_block_t)task
                  completion:(void (^)(NSString *taskName, uint64_t nanoseconds))completion;
@end
