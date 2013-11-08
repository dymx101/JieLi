//
//  RegViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-13.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "RegViewController.h"
#import "DiyTopBar.h"
#import "PicNameMc.h"
#import "AppDelegate.h"
#import "MemberAreaViewController.h"
@interface RegViewController (){
    
    IBOutlet DiyTopBar *topBar;
    IBOutlet UIImageView *bGA;
    IBOutlet UIImageView *bGB;
    IBOutlet UIImageView *iVA;
    IBOutlet UIImageView *iVB;
    
    IBOutlet UITextField *accountName;
    IBOutlet UITextField *passWord;
    
    IBOutlet UIButton *regButton;
    
}

@end

@implementation RegViewController

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
    [topBar setType:DiyTopBarTypeBack];
    topBar.myTitle.text = @"会员注册";
    [topBar.backButton setTitle:@"取消" forState:UIControlStateNormal];
    [topBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [bGA setImage:[PicNameMc inputImagewithView:bGA]];
    [bGB setImage:[PicNameMc inputImagewithView:bGB]];
    
    [iVA setImage:[[PicNameMc imageName:@"loginIcon@2x.png" numberOfH:2 numberOfW:1] objectAtIndex:0]];
    [iVB setImage:[[PicNameMc imageName:@"loginIcon@2x.png" numberOfH:2 numberOfW:1] objectAtIndex:1]];
    [regButton setImage:[PicNameMc buttonBg:regButton title:@"注册"] forState:UIControlStateNormal];

}
-(BOOL)checkBeforePost{
    if (accountName.text.length==0||passWord.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败" message:@"账号或密码不能为空" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"关闭", nil];
        [alertView show];
        return NO;
    }
    return YES;
    
}

- (IBAction)reg:(id)sender {
    if ([self checkBeforePost]) {
        NSString *urlString = [NSString stringWithFormat:@"?c=Member&m=register&user=%@&password=%@",accountName.text,passWord.text];
        BasicOperation *op = [[BasicOperation alloc] initWithUrl:urlString];
        op.delegate = self;
        [[AppDelegate shareQueue] addOperation:op];

    }

}
-(void)finishOperation:(id)result{
    int symble = [[result objectForKey:@"result"] integerValue];
    if (symble==1) {
        [AppDelegate setdAccountName:accountName.text];
        [AppDelegate setdPassWord:passWord.text];
        
        MemberAreaViewController *viewController = [[MemberAreaViewController alloc] initWithNibName:@"MemberAreaViewController" bundle:nil];
        viewController.memberInfo = result;

        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"账号或密码错误" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"关闭", nil];
        [alertView show];
        
    }
    
}
- (IBAction)bkTap:(id)sender {
    [self returnKeyBoard];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textFiel{
    [self returnKeyBoard];
    return YES;
}

-(void)returnKeyBoard{
    [accountName endEditing:YES];
    [passWord endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[AppDelegate shareQueue] cancelAllOperations];
}

- (void)viewDidUnload {
    bGA = nil;
    bGB = nil;
    iVA = nil;
    iVB = nil;
    accountName = nil;
    passWord = nil;
    regButton = nil;
    topBar = nil;
    [super viewDidUnload];
}
@end
