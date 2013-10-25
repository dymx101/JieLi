//
//  MemberAreaViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-24.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyTopBar.h"
#import "LogAndRegister.h"
#import "DataBrain.h"
#import "CellA.h"
#import "MemberInformationView.h"
#import "BasicOperation.h"
#import "BookShelfTableViewController.h"

@interface MemberAreaViewController : UIViewController<LogAndRegisterDelegate,BasicOperationDelegate,BookShelfTableViewControllerDelegate>
@property (strong, nonatomic) IBOutlet DiyTopBar *myTopBar;



@property (strong, nonatomic) IBOutlet UIImageView *myBgImageView;

@property (strong, nonatomic) IBOutlet UIButton *barButon1;
@property (strong, nonatomic) IBOutlet UIButton *barButon2;
@property (strong, nonatomic) IBOutlet UIButton *barButon3;
@property (strong, nonatomic) IBOutlet UIButton *barButon4;


@property (strong, nonatomic) IBOutlet UIImageView *meberAreaTopBar;

@property (strong, nonatomic) IBOutlet UIView *myMemberAreaView;
@property (strong,nonatomic) LogAndRegister *logAndRegisterView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (assign,nonatomic) int currentType;
@property (strong,nonatomic) MemberInformationView *informationView;

@property (strong,nonatomic) id memberInfo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actI;
@end
