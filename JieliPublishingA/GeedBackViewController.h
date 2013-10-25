//
//  GeedBackViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 13-2-26.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyTopBar.h"
@interface GeedBackViewController : UIViewController
@property (strong, nonatomic) IBOutlet DiyTopBar *diyTopBar;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UITextField *textFildA;
@property (retain, nonatomic) IBOutlet UITextField *textFildContract;

@end
