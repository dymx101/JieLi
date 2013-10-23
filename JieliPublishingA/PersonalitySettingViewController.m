//
//  PersonalitySettingViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-24.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "PersonalitySettingViewController.h"
#import "PicNameMc.h"
#import "BDAccountViewController.h"
#import "GeedBackViewController.h"
#import "AboutUsViewController.h"
#import "VisionUpDate.h"
#import "UserHelpViewController.h"

#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@interface PersonalitySettingViewController ()
{
    NSArray *leftImageArray;
}
@end

@implementation PersonalitySettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.myTopBar updateThemeColor];
    [self.myBgImageView setImage:[PicNameMc backGroundImage]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.myBgImageView setImage:[PicNameMc backGroundImage]];

    [self.myTopBar setType:DiyTopBarTypeBack];
    self.myTopBar.myTitle.text = @"个性设置";
    [self.myTopBar.backButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    
    leftImageArray = [[NSArray alloc] initWithObjects:
                      F_image_sina,
                      
                      F_iamge_tencent,
                      F_image_renren,
                      F_image_presetThemes,
                      F_image_themeD,
                      F_image_wifiHD,
                      F_image_removeCache,
                      
                      F_image_geedback,
                      F_image_aboutUs,
                      F_image_versionUpdate,
                      F_image_help,

                      nil];
    
    
        

    

}


-(NSString *)calculatedCapacity{
    NSFileManager *fM = [NSFileManager defaultManager];
    NSArray *fileList = [fM contentsOfDirectoryAtPath:kDocument_Folder error:nil];
    
    
    const unsigned int bytes = 1024*1024 ;
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    [formatter setPositiveFormat:@"##0.00"];
    
    float size;
    NSString *path;
    
    
    //NSString *extension;
    for (int i = 1; i<[fileList count]; i++) {
        NSString *pathA = [kDocument_Folder stringByAppendingPathComponent:[fileList objectAtIndex:i]];
        NSArray *fileListAA = [fM contentsOfDirectoryAtPath:pathA error:nil];
        
        for(NSString *file in fileListAA) {
            
            path = [pathA stringByAppendingPathComponent:file];
            
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            
            size=size+(float)[fileAttributes fileSize];
            
        }
    }
    NSNumber *total = [NSNumber numberWithFloat:(size/bytes)];
    
    NSLog(@"%@",[NSString stringWithFormat:@"占用容量：%@ MB",[formatter stringFromNumber:total]]);
    return [formatter stringFromNumber:total];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setMyTopBar:nil];
    [self setMyTableView:nil];
    [self setMyBgImageView:nil];
    [super viewDidUnload];
}

#pragma Mark - tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 4;
            break;
        default:
            break;
    }
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSArray *array = [PicNameMc imageName:@"icon-set5.png" numberOfH:5 numberOfW:1];
    NSArray *arrayg = [PicNameMc imageName:@"icon-moer4@2x.png" numberOfH:4 numberOfW:1];

    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,(cell.frame.size.height-30)/2-2, 30, 30)];
    [cell addSubview:imageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,0, 200, cell.frame.size.height-3)];
    [textLabel setBackgroundColor:[UIColor clearColor]];
    [cell addSubview:textLabel];
    switch (section) {
        case 0:
            
            switch (row) {
                case 0:
                    [imageView setImage:[array objectAtIndex:row]];
                    textLabel.text = @"账号绑定";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (row) {
                case 0:
                    [imageView setImage:[array objectAtIndex:2]];
                    textLabel.text = @"预置主题";
                    break;
                case 1:
                    [imageView setImage:[array objectAtIndex:3]];

                    textLabel.text = [NSString stringWithFormat:@"缓存清空( %@ MB)",[self calculatedCapacity]];
                    break;
                case 2:
                    [imageView setImage:[array objectAtIndex:4]];

                    textLabel.text = @"打分鼓励";
                    break;
                default:
                    break;
            }

            break;
            case 2:
            switch (row) {

                case 0:
                    [imageView setImage:[arrayg objectAtIndex:0]];
                    textLabel.text = @"意见反馈";
                    break;
                case 1:
                    [imageView setImage:[arrayg objectAtIndex:1]];
                    textLabel.text = @"关于我们";
                    break;
                case 2:
                    [imageView setImage:[arrayg objectAtIndex:2]];
                    textLabel.text = @"版本更新";
                    break;
                case 3:
                    [imageView setImage:[arrayg objectAtIndex:3]];
                    textLabel.text = @"使用帮助";
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        BDAccountViewController  *bda = [[BDAccountViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:bda animated:YES];
    }
    else if (indexPath.section ==1) {
        if (indexPath.row ==0) {
            ThemesViewController *viewController = [[ThemesViewController alloc] initWithNibName:@"ThemesViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];

        }
        else if (indexPath.row ==1){
            NSString *mes = [NSString stringWithFormat:@"清除缓存%@ MB",[self calculatedCapacity]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"缓存清空" message:mes delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alertView.tag = 10020;
            [alertView show];
            

        }
    }
    else if (indexPath.section == 2){
        int row = indexPath.row;
        
        if (row == 0) {
            GeedBackViewController *viewController = [[GeedBackViewController alloc] initWithNibName:@"GeedBackViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (row == 1){
            AboutUsViewController *viewController = [[AboutUsViewController alloc] initWithNibName:@"AboutUsViewController" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (row == 2){
            VisionUpDate *viewController = [[VisionUpDate alloc] initWithNibName:@"VisionUpDate" bundle:nil];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        else if (row == 3){
           UserHelpViewController *viewController = [[UserHelpViewController alloc] initWithNibName:@"UserHelpViewController" bundle:nil];
           [viewController setHidesBottomBarWhenPushed:YES];
           [self.navigationController pushViewController:viewController animated:YES];
           [viewController release];
           viewController = nil;
           
        }


    }

}
-(void)removeItems{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    NSLog(@"%@",fileList);
    for (int i = 0; i<[fileList count]; i++) {
        [fileManager removeItemAtPath:[fileList objectAtIndex:i] error:nil];
        
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10020) {
        switch (buttonIndex) {
            case 0:
                [self removeItems];
                [self.myTableView reloadData];

                break;
            case 1:
                break;
            default:
                break;
        }
    }
}


@end
