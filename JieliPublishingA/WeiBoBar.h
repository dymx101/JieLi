//
//  WeiBoBar.h
//  JieliPublishingA
//
//  Created by 花 晨 on 12-12-21.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KeyStyleOfSina @"sina"
#define KeyStyleofTen @"ten"
#define KEyStyleOfWeiXin @"weixin"
enum {
    LogInState,
    ShareState,
};
enum{
    ShareSelected,
    ShareUnSelected,
};

@class WeiBoBar;
@protocol WeiBoDelegate <NSObject>

-(void)logInWithWerboBar:(WeiBoBar *)weiBoBar;

@end
@interface WeiBoBar : UIView<UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (assign,nonatomic) int state;
@property (strong,nonatomic) NSString *logInString;
@property (strong,nonatomic) NSString *shareString;

@property (assign,nonatomic) BOOL isSelected;

@property (assign,nonatomic) id<WeiBoDelegate> delegate;

@property (assign,nonatomic) NSString *weiBoStyle;

-(void)setImage:(UIImage *)image;
-(void)setImageU:(UIImage *)imageU setImageB:(UIImage *)imageB;

-(void)setTextWithLogeIn:(NSString *)textA withShare:(NSString *)textB;
-(void)checkSelected;
@end
