//
//  MyScores.h
//  JieLiShelf
//
//  Created by HuaChen on 13-10-22.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScores : UIView

@property (retain,nonatomic) UIViewController *fatherController;

@property (retain, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *ruleScrollView;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property (retain, nonatomic) IBOutlet UITableView *exchangeTableView;



@property (retain, nonatomic) IBOutlet UILabel *accuntLable;
@property (retain, nonatomic) IBOutlet UILabel *scoreLable;

@property (assign,nonatomic) NSString *user_id;
@property (retain,nonatomic) NSMutableArray *details;

@property (nonatomic,strong) id bookExchangeJson;
//@property (nonatomic,strong) id 
@property (nonatomic,strong) NSMutableArray *exchangeBookInfoArray;
-(void)loadInfo:(NSDictionary *)dic;


@end
