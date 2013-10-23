//
//  GetProductsList.h
//  JieLiShelf
//
//  Created by HuaChen on 13-9-5.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetProductsList : NSOperation


+(void)getProductsList:(void (^)(BOOL success,id result))getFinish;

@end
