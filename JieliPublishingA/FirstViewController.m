//
//  FirstViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-12.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "FirstViewController.h"
#import "GoodBookViewController.h"
#import "SeachBookstoreViewController.h"
#import "PromotionViewController.h"
#import "ReadingActivityViewController.h"
#import "PersonalitySettingViewController.h"
#import "MemberAreaViewController.h"
#import "PicNameMc.h"

#import "LogViewController.h"
#import "RegViewController.h"

#import "Reachability.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.view.backgroundColor = [UIColor blackColor];
        self.title = NSLocalizedString(@"首页", @"首页");
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_1"];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    NSArray *images = [PicNameMc homeIcons];
    NSArray *buttons = [NSArray arrayWithObjects:self.firstButton,self.secondButton,self.thridButton,self.forthButton,self.fifthButton,self.sixButton, nil];
    for (int i = 0; i<[buttons count]; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        [button setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
    }
    [self.myDiyTopBar updateThemeColor];
    
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.myDiyTopBar setType:DiyTopBarTypeNone];
    [self.myDiyTopBar.myTitle setText:@"接力阅读时空"];
    
    NSArray *images = [PicNameMc homeIcons];
    NSArray *buttons = [NSArray arrayWithObjects:self.firstButton,self.secondButton,self.thridButton,self.forthButton,self.fifthButton,self.sixButton, nil];
    for (int i = 0; i<[buttons count]; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        [button setImage:[images objectAtIndex:i] forState:UIControlStateNormal];
    }
    
    
    [self.myWoodBg setImage:[PicNameMc imageFromImageName:F_bg]];
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];

    self.tagIndex = 100;
    
	// Do any additional setup after loading the view, typically from a nib.
    int numberOfPages = 3;
    self.MyScrollorView.contentSize = CGSizeMake(self.MyScrollorView.bounds.size.width*numberOfPages, 0);
    [self.MyScrollorView setShowsHorizontalScrollIndicator:NO];
    for (int i = 0; i<numberOfPages; i++) {
        UIImageView *imgageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.MyScrollorView.frame.size.width*i, 0, self.MyScrollorView.frame.size.width, self.MyScrollorView.frame.size.height)];
        [self.MyScrollorView addSubview:imgageView];
        switch (i) {
            case 0:
                [imgageView setBackgroundColor:[UIColor blueColor]];
                [imgageView setImage:[UIImage imageNamed:@"brand1.png"]];
                break;
            case 1:
                [imgageView setBackgroundColor:[UIColor redColor]];
                [imgageView setImage:[UIImage imageNamed:@"brand2.png"]];
                break;
            case 2:
                [imgageView setBackgroundColor:[UIColor yellowColor]];
                [imgageView setImage:[UIImage imageNamed:@"brand3.png"]];
                break;
            case 3:
                [imgageView setBackgroundColor:[UIColor purpleColor]];
                break;
            case 4:
                [imgageView setBackgroundColor:[UIColor orangeColor]];
                break;
            default:
                break;
        }
        [imgageView release];
        imgageView = nil;
    }
    self.MyPageControl.numberOfPages = numberOfPages;
    self.MyPageControl.currentPage = 0;
    [self.MyScrollorView setBackgroundColor:[UIColor grayColor]];
}
-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES];
}
-(BOOL)checkNetWorkState{
    if (([Reachability reachabilityForInternetConnection].currentReachabilityStatus == NotReachable) &&
        ([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable)) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"接力阅读时空"
                                                        message:@"当前无网络连接，请检查网络连接"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        return NO;
    }
    return YES;

}
//到接力好书
- (IBAction)pushToGoodBook:(id)sender {
    if ([self checkNetWorkState]) {
        GoodBookViewController *viewController = [[GoodBookViewController alloc] initWithNibName:@"GoodBookViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        viewController = nil;
    }
}
//到促销优惠
- (IBAction)pushToPromotion:(id)sender {
    if ([self checkNetWorkState]) {
    PromotionViewController *viewController = [[PromotionViewController alloc] initWithNibName:@"PromotionViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        viewController = nil;
 }
}
//到读书活动
- (IBAction)pushToReadingParty:(id)sender {
    if ([self checkNetWorkState]) {
    ReadingActivityViewController *viewController = [[ReadingActivityViewController alloc] initWithNibName:@"ReadingActivityViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        viewController = nil;
 }
}
//到身边书店
- (IBAction)pushToSeachBookstore:(id)sender {
    if ([self checkNetWorkState]) {
    SeachBookstoreViewController *viewController = [[SeachBookstoreViewController alloc] initWithNibName:@"SeachBookstoreViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        viewController = nil;
 }
}
//到会员专区
- (IBAction)pushToMemberArea:(id)sender {
    if ([self checkNetWorkState]) {

    if (![AppDelegate dAccountName]) {
        LogViewController *viewController = [[LogViewController alloc] initWithNibName:@"LogViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        viewController = nil;
  }
    else{
        MemberAreaViewController *viewController = [[MemberAreaViewController alloc] initWithNibName:@"MemberAreaViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
        viewController = nil;
 }
    }
}
//到个性设置
- (IBAction)pushToSetPersonality:(id)sender {
    PersonalitySettingViewController *viewController = [[PersonalitySettingViewController alloc] initWithNibName:@"PersonalitySettingViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
    viewController = nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = self.MyScrollorView.contentOffset.x /self.MyScrollorView.bounds.size.width;
    //通过滚动的偏移量来判断目前页面所对应的小白点
    self.MyPageControl.currentPage = page;//pagecontroll响应值的变化
}// any offset changes


- (IBAction)changePage:(id)sender {
    int page = self.MyPageControl.currentPage;//获取当前pagecontroll的值
    [self.MyScrollorView setContentOffset:CGPointMake(self.MyScrollorView.bounds.size.width * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyScrollorView:nil];
    [self setMyPageControl:nil];
    [self setFirstButton:nil];
    [self setFirstlabel:nil];
    [self setSecondButton:nil];
    [self setForthButton:nil];
    [self setFifthButton:nil];
    [self setSixButton:nil];
    [self setMyNavigationBar:nil];
    [self setMyWoodBg:nil];
    [self setMyDiyTopBar:nil];
    [self setBackGroundImageView:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [_backGroundImageView release];
    [super dealloc];
}
@end
