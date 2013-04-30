//
//  BasicOperation.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-13.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "BasicOperation.h"
#define BaseURL @"http://www.jielibj.com/ws/webs.php"

@interface BasicOperation (){
    NSString *urlString;
    id target;
    SEL sel;
}

@end

@implementation BasicOperation

+(id)basicOperationWithUrl:(NSString *)url withTaget:(id)t select:(SEL)s{
    return [[self alloc] initWithUrl:url withTaget:t select:s];
}

-(id)initWithUrl:(NSString *)url withTaget:(id)t select:(SEL)s{
    if (self == [super init]) {
        urlString = [url retain];
        target = t;
        sel = s;
    }
    return self;
}
-(id)initWithUrl:(NSString *)url{
    if (self == [super init]) {
        urlString = [url retain];
    }
    return self;
}
-(void)main{
    
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (!data) {
        return;
    }
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if (target) {
        [target performSelectorOnMainThread:sel withObject:result waitUntilDone:NO];
    }
    else{
        [self performSelectorOnMainThread:@selector(finish:) withObject:result waitUntilDone:NO];
    }
}

-(void)finish:(id)result{
    if ([self.delegate respondsToSelector:@selector(finishOperation:)]) {
        [self.delegate finishOperation:result];
    }
    else if ([self.delegate respondsToSelector:@selector(finishOperationWithOperation:result:)]){
        [self.delegate finishOperationWithOperation:self result:result];
    }

}
@end
