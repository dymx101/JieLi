//
//  HCDownLoadingView.m
//  JieliPublishingA
//
//  Created by HuaChen on 13-5-20.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "HCDownLoadingView.h"
#define DownViewFrame CGRectMake(40, 200, 240, 130)


@interface HCDownLoadingView (){
    CloseResult closeResult;
}

@end

@implementation HCDownLoadingView

+(id)DownLoadingView{
    return [[self alloc] initWithFrame:DownViewFrame withClose:nil];
}
+(id)DownLoadingViewWithClose:(CloseResult)result{
    
    return [[self alloc] initWithFrame:DownViewFrame withClose:result];
};

- (id)initWithFrame:(CGRect)frame withClose:(CloseResult )result
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        closeResult = result;
        
        UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [backGroundImageView setImage:[[UIImage imageNamed:@"loadingbar"]stretchableImageWithLeftCapWidth:30/2 topCapHeight:130/2]];
        [self addSubview:backGroundImageView];
        
        UIImage *image = [UIImage imageNamed:@"cancelloading"];
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake((self.frame.size.width - image.size.width)/2, 10, image.size.width, image.size.height)];
        [closeButton setImage:image forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        self.proGressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.proGressView.center = CGPointMake(self.bounds.size.width/2, 75);
        [self addSubview:self.proGressView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width - 140)/2, 80, 140, 40)];
        [label setText:@"读取中，请稍候..."];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
//        [label setFont:[[UIFont alloc] fontWithSize:14]];
        [self addSubview:label];
        
        
        
        
        
    }
    return self;
}
-(void)closeButtonPressed{
    if (closeResult) {
        closeResult();
    }
    [self.delegate HCDownLoadingViewClose:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
