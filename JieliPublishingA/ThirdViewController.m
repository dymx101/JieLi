//
//  ThirdViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-15.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "ThirdViewController.h"
#import "PicNameMc.h"
#import "GoodBookViewController.h"
#import "Reachability.h"

@interface ThirdViewController ()
@property (nonatomic,strong) BookShelfTableViewController *tC;

@end

@implementation ThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"收藏", @"收藏");
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_3"];
        // Custom initialization
        
    }
    return self;
}

-(void)awakeFromNib{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];

    self.myBookShelf.showPrice = NO;
    [self.myBookShelf reloadData];
    
    [self.myDiyTopBar.myTitle setText:@"图书收藏"];
    
    NSLog(@"%@",[AppDelegate getCollectedBooks]);
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    [self.myDiyTopBar updateThemeColor];
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];

    if ([[AppDelegate getCollectedBooks] count]) {
        self.noCollectButton.hidden = YES;
        self.noCollectImageview.hidden = YES;
        if (self.tC) {
            [self.tC.tableView removeFromSuperview];
            self.tC = nil;
        }
        
        self.tC = [[BookShelfTableViewController alloc] initWithStyle:UITableViewStylePlain];
        self.tC.delegate = self;
        [self.tC.tableView setBackgroundColor:[UIColor clearColor]];
        [self.tC.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tC.tableView setShowsVerticalScrollIndicator:NO];
        [self.tC loadBooks:[[AppDelegate getCollectedBooks] retain]];
        [self.tC.tableView setFrame:CGRectMake(0, 85-41, 320,326+41)];
        [self.view addSubview:self.tC.tableView];

    }
    else{
        self.noCollectButton.hidden = NO;
        self.noCollectImageview.hidden = NO;
        if (self.tC) {
            [self.tC.tableView removeFromSuperview];
            self.tC = nil;
        }
    }
}
-(void)pushOut:(HCTadBarController *)tab{
    
    [self.navigationController pushViewController:tab animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toGoodBook:(id)sender {
    if ([self checkNetWorkState]) {
        GoodBookViewController *viewController = [[GoodBookViewController alloc] initWithNibName:@"GoodBookViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }

}

- (void)viewDidUnload {
    [self setMyBookShelf:nil];
    [self setMyDiyTopBar:nil];
    [self setNoCollectImageview:nil];
    [self setNoCollectButton:nil];
    [self setBackGroundImageView:nil];
    [super viewDidUnload];
}



- (void)dealloc {
    [_noCollectImageview release];
    [_noCollectButton release];
    [_backGroundImageView release];
    [super dealloc];
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

@end
