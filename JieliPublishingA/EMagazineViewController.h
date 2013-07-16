//
//  EMagazineViewController.h
//  JieliPublishingA
//
//  Created by HuaChen on 13-5-28.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMagazineViewController : UIViewController<UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UILabel *pageNumber;
@property (retain, nonatomic) IBOutlet UIView *topBar;
@property (retain, nonatomic) IBOutlet UIButton *popBackButton;
@property (retain,nonatomic) NSArray *pageArray;
-(void)addEMagazineWithIndex:(int)index;

@end
