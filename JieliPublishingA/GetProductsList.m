//
//  GetProductsList.m
//  JieLiShelf
//
//  Created by HuaChen on 13-9-5.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "GetProductsList.h"

@implementation GetProductsList
+(void)getProductsList:(void (^)(BOOL success,id result))getFinish{
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"com.t1",
                                 @"com.t2",
                                 @"com.000396",
                                 @"com.000380",
                                 @"com.000360",
                                 nil];

    getFinish(YES,productIdentifiers);
    
    
}

@end
