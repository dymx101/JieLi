//
//  AppDelegate.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-12.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"

#import "CustomNavigationBar.h"
#import "Reachability.h"

#import "LocalEpubBookViewController.h"
//#import "DOUAPIEngine.h"
//sina
#define SinaAppKey             @"1121796814"
#define SinaAppSecret          @"152a12ee831277740fb7ef7708ca65eb"
#define SinaAppRedirectURI     @"http://www.apple.com"

//百度apiKey
#define BMAPAPIKEY @"206AC53E67C539B6539AF6C41F48AB42562BDE6B"
//豆瓣Api
static NSString * const kAPIKey = @"078978195e42393f169c684c1ac6abbd";
static NSString * const kPrivateKey = @"c1e44680a06e5e4a";
static NSString * const kRedirectUrl = @"http://www.douban.com/location/mobile";

#define BookCollect @"bookcollect"
static NSOperationQueue *queue;

@implementation AppDelegate

//本地收藏图书
+(BOOL)idCollectedBook:(BookInfo *)bookInfo{
    NSMutableArray *books = [NSMutableArray arrayWithArray:[[self class] getCollectedBooks]] ;
    for (BookInfo *info in books) {
        if (info.bookId == bookInfo.bookId) {
            return YES;
        }
    }
    return NO;
}
+(void)collectABook:(BookInfo *)bookInfo{
    NSMutableArray *books = [NSMutableArray arrayWithArray:[[self class] getCollectedBooks]] ;
    BookInfo *delInfo = nil;
    for (BookInfo *info in books) {
        if (info.bookId == bookInfo.bookId) {
            delInfo = info;
        }
    }
    if (delInfo) {
        [books removeObject:delInfo];
    }
    else{
        [books addObject:bookInfo];
    }
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"test"];
    [NSKeyedArchiver archiveRootObject:books toFile:filename];
    
//    NSMutableData *data = [[NSMutableData alloc] init];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
//    [archiver encodeObject:books forKey:BookCollect];
//    [archiver finishEncoding];
//    BOOL success  = [data writeToFile:filename atomically:YES];
//    archiver = nil;
//    data = nil;
    
}
+(NSArray *)getCollectedBooks{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"test"];
    NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    if (arr) {
        return arr;
    }
    else{
        
        return [NSArray array];
    }
    
//    NSData *data = [[NSData alloc] initWithContentsOfFile:filename];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
//    NSArray *array = [unarchiver decodeObjectForKey:BookCollect];
    
}

//用户名，密码相关
+(void)dLogInWithUserId:(NSString *)userId accountName:(NSString *)accountName passWord:(NSString *)passWord{
    [AppDelegate setdUserId:userId];
    [AppDelegate setdAccountName:accountName];
    [AppDelegate setdPassWord:passWord];

}
+(void)dLogOut{
    [AppDelegate setdUserId:nil];
    [AppDelegate setdAccountName:nil];
    [AppDelegate setdPassWord:nil];
}

+(NSString *)dUserId{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}
+(void)setdUserId:(NSString *)v{
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:@"userId"];
}

+(NSString *)dAccountName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accountName"];
}
+(void)setdAccountName:(NSString *)v{
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:@"accountName"];
}
+(NSString *)dPassWord{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
}
+(void)setdPassWord:(NSString *)v{
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:@"passWord"];
}

//网络请求队列
+(id)shareQueue{
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:1];
    }
    return queue;
}

-(DataBrain *)dataBrain{
    if (!_dataBrain) {
        _dataBrain = [[DataBrain alloc] init];
    }
    
    return _dataBrain;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [ShareSDK registerApp:@"520520test"];
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:SinaAppKey
                               appSecret:SinaAppSecret
                             redirectUri:SinaAppRedirectURI];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:BMAPAPIKEY generalDelegate:nil];
    if (ret == NO) {
        NSLog(@"manager start failed!");
    }
    
//    DOUService *service = [DOUService sharedInstance];
//    service.clientId = kAPIKey;
//    service.clientSecret = kPrivateKey;
//    if ([service isValid]) {
//        service.apiBaseUrlString = kHttpsApiBaseUrl;
//    }
//    else {
//        service.apiBaseUrlString = kHttpApiBaseUrl;
//    }
    

    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UINavigationController *navigationController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    navigationController1.delegate = self;
    [navigationController1 setNavigationBarHidden:YES];
    [viewController1 release];
    viewController1 = nil;
    
    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    UINavigationController *navigationController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    [navigationController2 setNavigationBarHidden:YES];
    [viewController2 release];
    viewController2 = nil;

    
    UIViewController *viewController3 = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
    UINavigationController *navigationController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    [navigationController3 setNavigationBarHidden:YES];
    [viewController3 release];
    viewController3 = nil;

    
    
    LocalEpubBookViewController *viewController4 = [[LocalEpubBookViewController alloc] initWithNibName:@"LocalEpubBookViewController" bundle:nil];
//    UIViewController *viewController4 = [[ForthViewController alloc] initWithNibName:@"ForthViewController" bundle:nil];
    UINavigationController *navigationController4 = [[UINavigationController alloc] initWithRootViewController:viewController4];
    [navigationController4 setNavigationBarHidden:YES];
    [viewController4 release];
    viewController4 = nil;


    
    UITabBarController *tbc = [[UITabBarController alloc] init];
    tbc.viewControllers = @[navigationController1, navigationController2,navigationController3,navigationController4];
    self.window.rootViewController = tbc;
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = @[navigationController1, navigationController2,navigationController3,navigationController4];
//    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [navigationController1 release];
    navigationController1= nil;
    [navigationController2 release];
    navigationController2= nil;
    [navigationController3 release];
    navigationController3= nil;
    [navigationController4 release];
    navigationController4= nil;
    
    [tbc release];
    tbc = nil;

    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [[Reachability reachabilityWithHostName:@"http://www.jielibj.com"] retain];
    [hostReach startNotifier];

    return YES;
}
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接力阅读小栈"
                                                        message:@"当前无网络连接，请检查网络连接"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    
//    
//    if ([viewController isMemberOfClass:[FirstViewController class]]) {
//        
//    }
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

-(void)dealloc{
    [super dealloc];
    self.tabBarController = nil;
    self.window = nil;
}
@end
