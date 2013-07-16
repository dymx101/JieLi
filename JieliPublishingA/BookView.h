//
//  BookView.h
//  JieliPublishingA
//
//  Created by 花 晨 on 13-1-29.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookInfo.h"
#import "NetImageView.h"


#define  ImageViewWith  80.f
#define  ImageViewHight  116.f
#define LabelHight 30.f
#define AIViewWith 30.f
#define AIViewHight 30.f

@class BookView;

@protocol BookViewDelegate <NSObject>
-(void)bookViewBeTouched:(BookView*)bookView;
-(void)bookViewBeDelete:(BookView *)bookView;
@end

@interface BookView : UIView<UIGestureRecognizerDelegate,NetImageViewDelegate>
@property (strong, nonatomic)  UIImageView *imageView;
@property (strong, nonatomic)  UILabel *labelView; 
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong,nonatomic) BookInfo *bookInfo;
@property (assign,nonatomic) id <BookViewDelegate> delegate;

@property (assign,nonatomic) BOOL isLoadImageFinish;
@property (strong,nonatomic) UIButton *delButton;


+(id)BookViewWithBookInfo:(BookInfo*)bookInfo withPosition:(CGPoint)position;
+(id)BookViewWithBookInfo:(BookInfo*)bookInfo;

-(id)initWithFrame:(CGRect)frame withCoverImage:(UIImage *)coverImage withLableName:(NSString*)lableName;
-(id)initWithFrame:(CGRect)frame withCoverImageUrl:(NSString *)coverImageUrl withLableName:(NSString *)lableName;
-(void)editModelStart;
-(void)editModelEnd;
//-(void)addTaget:(id)taget action:(SEL)action;
@end
