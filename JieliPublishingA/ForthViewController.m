//
//  ForthViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-15.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "ForthViewController.h"
#import "PicNameMc.h"
#import "GeedBackViewController.h"
#import "AboutUsViewController.h"
#import "VisionUpDate.h"
#import "UserHelpViewController.h"

@interface ForthViewController (){
    NSArray *leftImageArray;
}

@end

@implementation ForthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"更多", @"更多");
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_4"];
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myDiyTopBar.myTitle setText:@"更多"];
    
    leftImageArray = [[NSArray alloc] initWithObjects:
                      F_image_geedback,
                      F_image_aboutUs,
                      F_image_versionUpdate,
                      F_image_help,
                      nil];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma Mark - tableDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

    NSInteger row = indexPath.row;
    NSArray *array = [PicNameMc imageName:@"icon-moer4@2x.png" numberOfH:4 numberOfW:1];
    
    NSLog(@"%@",array);
    [cell setImage:[array objectAtIndex:row]];
    switch (row) {
        case 0:
            cell.textLabel.text = @"意见反馈";
            break;
        case 1:
            cell.textLabel.text = @"关于我们";
            break;
        case 2:
            cell.textLabel.text = @"版本更新";
            break;
        case 3:
            cell.textLabel.text = @"使用帮助";
            break;
            
        default:
            break;
    }
return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    
    if (row == 0) {
        GeedBackViewController *viewController = [[GeedBackViewController alloc] initWithNibName:@"GeedBackViewController" bundle:nil];
        [self.navigationController pushViewController:viewController animated:YES];
       [viewController release];
       viewController = nil;

    }
    else if (row == 1){
       AboutUsViewController *viewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
       [self.navigationController pushViewController:viewController animated:YES];
       [viewController release];
       viewController = nil;

    }
    else if (row == 2){
       VisionUpDate *viewController = [[VisionUpDate alloc] initWithNibName:@"VisionUpDate" bundle:nil];
       [self.navigationController pushViewController:viewController animated:YES];
       [viewController release];
       viewController = nil;
       
    }
//    else if (row == 3){
//       UserHelpViewController *viewController = [[UserHelpViewController alloc] initWithNibName:@"UserHelpViewController" bundle:nil];
//       [self.navigationController setHidesBottomBarWhenPushed:YES];
//       [self.navigationController pushViewController:viewController animated:YES];
//       [viewController release];
//       viewController = nil;
//       
//    }
   
}


- (void)viewDidUnload {
    [self setMyDiyTopBar:nil];
    [super viewDidUnload];
}
@end
