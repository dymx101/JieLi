//
//  CommentViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicBookViewController.h"
#import "BookInfo.h"


#import "LogViewController.h"
@protocol CommentViewControllerDelegate <NSObject>
-(void)pushTo:(LogViewController *)v;


@end
@interface CommentViewController : BasicBookViewController<UIActionSheetDelegate>

@property (strong,nonatomic) BookInfo *bookInfo;
@property (strong,nonatomic) id<CommentViewControllerDelegate> delegate;

-(void)loadData:(id)result;
-(void)iWantComment;
@end
