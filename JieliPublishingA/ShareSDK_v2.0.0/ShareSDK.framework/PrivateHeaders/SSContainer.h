//
//  SSContainer.h
//  ShareSDKInterface
//
//  Created by vimfung on 13-4-7.
//  Copyright (c) 2013年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISSContainer.h"
#import "SSiPadViewController.h"

/**
 *	@brief	容器对象
 */
@interface SSContainer : NSObject <ISSContainer>
{
@private
    UIViewController *_iPhoneViewController;
    SSiPadViewController *_iPadViewController;
}

/**
 *	@brief	iPhone视图控制器
 */
@property (nonatomic,retain) UIViewController *iPhoneViewController;

/**
 *	@brief	iPad视图控制器
 */
@property (nonatomic,retain) SSiPadViewController *iPadViewController;

@end
