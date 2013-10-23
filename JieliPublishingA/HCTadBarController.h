//
//  HCTadBarController.h
//  testTabView
//
//  Created by 花 晨 on 13-3-5.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "BuyViewController.h"


//#import "EPubViewController.h"

@class HCTabBar;
@protocol HCTabBarDelegate <NSObject>

-(void)tabBar:(HCTabBar *)tabBar selectAtIndex:(NSUInteger)index;

@end

@interface HCTabBar : UIView
@property (nonatomic,assign) id<HCTabBarDelegate> delegate;
@property (nonatomic, assign) NSUInteger            selectedIndex;
-(void)reSetSelectedImageViewCenterWithButtonTag:(int)index animated:(BOOL)animated;
-(void)buttonPressed:(UIButton *)button;

@end








//-----------------------------
typedef enum {
    CollectButtonTypeOfCollect,
    CollectButtonTypeOfDelect,
}CollectButtonType;
#import "BookInfo.h"
#import "BookDetailViewController.h"
@interface HCTadBarController : UIViewController<UIScrollViewDelegate,HCTabBarDelegate,BookDetailDelegate,CommentViewControllerDelegate>
@property (nonatomic,strong) NSArray *viewControllers;
@property (nonatomic,strong) HCTabBar *tabBar;
@property (nonatomic, assign) NSUInteger            selectedIndex;
@property (nonatomic,strong) BookInfo *bookInfo;
-(void)setSelectedIndex:(NSUInteger)selectedIndex;

@end
