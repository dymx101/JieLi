//
//  MyScores.h
//  JieLiShelf
//
//  Created by HuaChen on 13-10-22.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScores : UIView
@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *ruleScrollView;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) IBOutlet UILabel *accuntLable;
@property (retain, nonatomic) IBOutlet UILabel *scoreLable;

@property (assign,nonatomic) NSString *user_id;
@property (retain,nonatomic) NSMutableArray *details;
-(void)loadInfo:(NSDictionary *)dic;

@end
