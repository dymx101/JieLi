//
//  ReadRulerViewController.m
//  JieLiShelf
//
//  Created by HuaChen on 13-9-9.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "ReadRulerViewController.h"
#import "RegViewController.h"
#import "PicNameMc.h"
@interface ReadRulerViewController ()

@end

@implementation ReadRulerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_myTopBar setType:DiyTopBarTypeBack];
    _myTopBar.myTitle.text = @"会员章程";
    [_myTopBar.backButton setTitle:@"取消" forState:UIControlStateNormal];
    [_myTopBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self.agreeButton setImage:[PicNameMc buttonBg:_agreeButton title:@"同意"] forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_agreeButton release];
    [_myTopBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setAgreeButton:nil];
    [self setMyTopBar:nil];
    [super viewDidUnload];
}
- (IBAction)pushToReg:(id)sender {
    RegViewController *viewController = [[RegViewController alloc] initWithNibName:@"RegViewController" bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];

}
@end
