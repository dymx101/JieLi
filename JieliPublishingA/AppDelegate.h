//
//  AppDelegate.h
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-12.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataBrain.h"
#import "BMapKit.h"
#import <ShareSDK/ShareSDK.h>

@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate,UINavigationControllerDelegate>{
    BMKMapManager *_mapManager;
    
    Reachability  *hostReach;
    
    UIViewController *rootFirstViewController;
    NSDictionary *pushUserInfo;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong,nonatomic) DataBrain *dataBrain;
+(id)shareQueue;
+(NSString *)dAccountName;
+(void)setdAccountName:(NSString *)v;
+(NSString *)dPassWord;
+(void)setdPassWord:(NSString *)v;
+(NSString *)dUserId;
+(void)setdUserId:(NSString *)v;
+(void)dLogOut;
+(void)dLogInWithUserId:(NSString *)userId accountName:(NSString *)accountName passWord:(NSString *)passWord;
+(void)collectABook:(BookInfo *)bookInfo;
+(NSArray *)getCollectedBooks;
+(BOOL)idCollectedBook:(BookInfo *)bookInfo;

@end
