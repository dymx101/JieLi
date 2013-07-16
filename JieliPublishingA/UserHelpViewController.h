//
//  UserHelpViewController.h
//  JieLiShelf
//
//  Created by HuaChen on 13-7-9.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyTopBar.h"
@interface UserHelpViewController : UIViewController
@property (retain, nonatomic) IBOutlet DiyTopBar *topBar;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic)NSArray *helpImageArray;
@end
