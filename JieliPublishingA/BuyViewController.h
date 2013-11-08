//
//  BuyViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicBookViewController.h"
#import "BookInfo.h"
#import "HCDownLoadingView.h"
#import "HCDownLoad.h"

@interface BuyViewController : BasicBookViewController<UITableViewDataSource,UITableViewDelegate,HCDownLoadDelegate,HCDownLoadingViewDelegate,UIAlertViewDelegate>



@property (strong,nonatomic) BookInfo *bookInfo;
@property (strong,nonatomic) NSArray *arrayOfBuyBoooks;
@property (strong, nonatomic) UIViewController *tabBarController;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSString *exchangeScore;
@property (strong,nonatomic) NSString *exchange_id;
-(void)buy;
-(void)loadData:(id)result;
@end
