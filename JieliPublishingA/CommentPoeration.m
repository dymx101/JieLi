//
//  CommentPoeration.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-9.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "CommentPoeration.h"
#define BaseURL @"http://www.jielibj.com/ws/webs.php"

@implementation CommentPoeration

+(id)sendWithTaget:(id)cv userId:(NSString *)userid name:(NSString *)name BookId:(int)bookid content:(NSString *)content stars:(int)starsnumber{
    return [[self alloc] initWithTaget:self userId:userid name:name BookId:bookid content:content stars:starsnumber];
}


-(id)initWithTaget:(id)cv userId:(NSString *)userid name:(NSString *)name BookId:(int)bookid content:(NSString *)content stars:(int)starsnumber{
    if (self = [super init]) {
        target = [cv retain];
        type = CommentSend;
        NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=sendComment&userId=%@&name=%@&bookId=%d&content=%@&star=%d",userid,name,bookid,content,starsnumber];
        
//        url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        url = [NSURL URLWithString:[BaseURL stringByAppendingString:urlString]];
        url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

        NSLog(@"%@",[url retain]);
        

    }
    return self;
}

+(id)getWithTaget:(id)cv withBookId:(int)bookid{
    return [[self alloc] initWithTaget:cv withBookId:bookid];
}

-(id)initWithTaget:(id)cv withBookId:(int)bookid{
    if (self == [super init]) {
        target = [cv retain];
        type = CommentGet;
        NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getComment&bookId=%d",bookid];
        url = [[NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] retain];
        
    }
    return self;
}
-(void)main{
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSLog(@"sendC data:%@",data);
    if (!data) {
        return;
    }
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"sendc result:%@",result);
    NSLog(@"%@",url);
    [self performSelectorOnMainThread:@selector(finish:) withObject:result waitUntilDone:NO];
}
-(void)finish:(id)result{
    if (type == CommentGet) {
        [self.delegate getCommentFinish:result];
    }
    else{
        [self.delegate sendCommentFinish:result];
    }
    

}

@end
