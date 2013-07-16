//
//  SecondViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-12.
//  Copyright (c) 2012年 中卡. All rights reserved.
//
#ifdef DEBUG
#define DMLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DMLog(...) do { } while (0)
#endif

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DiyTopBar.h"
#import "SearchPoeration.h"
#import "BookShelfTableViewController.h"

#import "iflyMSC/SpeechUser.h"
#import "iflyMSC/UpLoadController.h"
#import "iflyMSC/IFlyRecognizeControl.h"




#define APPID @"50b3125a"
#define ENGINE_URL @"http://dev.voicecloud.cn:1028/index.htm"

@interface SecondViewController : UIViewController<DataBrainGetListDelegate,UpLoadControllerDelegate,IFlyRecognizeControlDelegate,SearchPoerationDelegate,BookShelfTableViewControllerDelegate>


@property (strong, nonatomic) IBOutlet DiyTopBar *myDiyTopBar;
@property (strong, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) IBOutlet UIImageView *myBgImageView;

@property (strong, nonatomic) IBOutlet UIImageView *sBackground;

@property (strong,nonatomic) AppDelegate *app;
@property (strong,nonatomic) DataBrain *dataBrain;


@property (strong,nonatomic) IFlyRecognizeControl *iFlyRecognizeControl;
@property (strong,nonatomic) NSString *lomeintest;
@end
