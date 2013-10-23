//
//  InAppJieLiIAPHelper.m
//  JieliPublishingA
//
//  Created by HuaChen on 13-5-28.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "InAppJieLiIAPHelper.h"

@implementation InAppJieLiIAPHelper
static InAppJieLiIAPHelper * _sharedHelper;
+ (InAppJieLiIAPHelper *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[InAppJieLiIAPHelper alloc] init];
    return _sharedHelper;
}
//- (id)init {
//    
//    NSSet *productIdentifiers = [NSSet setWithObjects:
//                                 @"com.t1",
//                                 @"com.t2",
//                                 @"com.000396",
//                                 @"com.000380",
//                                 @"com.000360",
//                                 nil];
//    
//    if ((self = [super initWithProductIdentifiers:productIdentifiers])) {
//        
//        
//    }
//    return self;
//    
//}
@end
