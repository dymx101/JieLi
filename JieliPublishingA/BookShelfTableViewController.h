//
//  BookShelfTableViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-12.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCell.h"
#import "HCTadBarController.h"
#import "ContentViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "BuyViewController.h"
@protocol BookShelfTableViewControllerDelegate <NSObject>
@optional
-(void)pushOut:(HCTadBarController *)tab;

@end
@interface BookShelfTableViewController : UITableViewController<BasicOperationDelegate>
@property (strong,nonatomic) id<BookShelfTableViewControllerDelegate> delegate;
-(void)loadBooks:(NSArray *)books;
@end
