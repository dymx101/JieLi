//
//  DiyTopBar.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-11-1.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "DiyTopBar.h"
#import <QuartzCore/QuartzCore.h>
#import "PicNameMc.h"
@implementation DiyTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        [self addJob];

    }
    return self;
}

-(void)awakeFromNib{
    [self setBackgroundColor:[UIColor blackColor]];
    [self addJob];
}


-(void)setType:(int)type{
    switch (type) {
        case DiyTopBarTypeNone:
            self.header_left.hidden = YES;
            self.header_right.hidden = YES;
            self.backButton.hidden = YES;
            self.collectButton.hidden = YES;
            break;
        case DiyTopBarTypeBack:
            self.backButton.hidden = NO;
            self.header_left.hidden = NO;
            break;
        case DiyTopBarTypeCollect:
            self.collectButton.hidden = NO;
            self.header_right.hidden = NO;
            break;
        case DiyTopBarTypeBackAndCollect:
            self.backButton.hidden = NO;
            self.header_left.hidden = NO;
            self.collectButton.hidden = NO;
            self.header_right.hidden = NO;
            break;
        default:
            break;
    }
}

-(void)updateThemeColor{
    UIImage *image = [PicNameMc diyTopBarBackGroundImage];
    [self.myImageView setImage:image];
}
-(void)addJob{
//    [PicNameMc defaultBackgroundImage];
//    UIImage *image = [self defaultBackgroundImage];
    UIImage *image = [PicNameMc diyTopBarBackGroundImage];
    self.myImageView = [[UIImageView alloc] initWithImage:image];
    self.myImageView.frame = self.frame;
    
//    [self.myImageView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:80/255.0 blue:30/255.0 alpha:1]];
    
    
    [self addSubview:self.myImageView];
    image = nil;
    
    
    self.myTitle = [[UILabel alloc] initWithFrame:self.frame];
    [self.myTitle setTextAlignment:NSTextAlignmentCenter];
    [self.myTitle setFont:[UIFont fontWithName:@"ArialMT" size:20]];
    self.myTitle.textColor = [UIColor whiteColor];
    [self.myTitle setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.myTitle];
    
    
    
    self.header_left = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tsl"]];
    [self addSubview:self.header_left];
    self.header_left.frame = CGRectMake(56, 0, self.header_left.frame.size.width, self.frame.size.height);
    
    
    self.header_right = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tsl"]];
    [self addSubview:self.header_right];
    self.header_right.frame = CGRectMake(self.frame.size.width-56, 0, self.header_right.frame.size.width, self.frame.size.height);

    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self addSubview:self.backButton];
    
    
    self.collectButton = [[UIButton alloc] initWithFrame:CGRectMake(320-56, 0,56, 44)];
    [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.collectButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self addSubview:self.collectButton];

    
    self.header_left.hidden = YES;
    self.header_right.hidden = YES;
    self.backButton.hidden = YES;
    self.collectButton.hidden = YES;
    
}
- (UIImage*)defaultBackgroundImage {
    CGFloat width = 640;
    // Get the image that will form the top of the background
    UIImage* topImage = [UIImage imageNamed:@"topBar_red"];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, self.frame.size.height), NO, 0.0);
    
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}


@end
