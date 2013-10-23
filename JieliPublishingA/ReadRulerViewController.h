//
//  ReadRulerViewController.h
//  JieLiShelf
//
//  Created by HuaChen on 13-9-9.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyTopBar.h"

@interface ReadRulerViewController : UIViewController
@property (retain, nonatomic) IBOutlet DiyTopBar *myTopBar;
@property (retain, nonatomic) IBOutlet UIButton *agreeButton;
- (IBAction)pushToReg:(id)sender;

@end
