//
//  ShareViewController.h
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicBookViewController.h"
#import "AppDelegate.h"
#import "WeiBoBar.h"

@protocol ShareViewDelegate <NSObject>

-(void)ShareEventSuccess;

@end


@interface ShareViewController : BasicBookViewController<WeiBoDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong,nonatomic) UIImage *sendImage;
@property (strong,nonatomic) NSString *bookId;
@property (strong,nonatomic) NSString *eventId;
@property (assign,nonatomic) id <ShareViewDelegate> delegate;
-(void)sendWeiBo;
@end
