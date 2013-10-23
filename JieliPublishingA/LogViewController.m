//
//  LogViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-13.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "LogViewController.h"
#import "PicNameMc.h"
#import "DiyTopBar.h"
#import "RegViewController.h"
#import "AppDelegate.h"
#import "MemberAreaViewController.h"
#import "ReadRulerViewController.h"

@interface LogViewController (){
    
    IBOutlet DiyTopBar *myDiyTopBar;
    IBOutlet UIImageView *txBgA;
    IBOutlet UIImageView *txBgB;
    IBOutlet UIImageView *iVA;
    IBOutlet UIImageView *iVB;
    
    IBOutlet UIButton *logInButton;
    IBOutlet UIButton *pushToRegButton;
    
    IBOutlet UITextField *accoutName;
    IBOutlet UITextField *password;
    
}

@end

@implementation LogViewController

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

-(BOOL)checkBeforePost{
    if (accoutName.text.length==0||password.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"账号或密码不能为空" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"关闭", nil];
        [alertView show];
        return NO;
    }
    return YES;
    
}


- (IBAction)logIn:(id)sender {
    if ([self checkBeforePost]) {
    NSString *urlString = [NSString stringWithFormat:@"?c=Member&m=login&user=%@&password=%@",accoutName.text,password.text];

    BasicOperation *op = [[BasicOperation alloc] initWithUrl:urlString];
    op.delegate = self;
    [[AppDelegate shareQueue] addOperation:op];
    
    }
}
-(void)finishOperation:(id)result  {
    NSLog(@"%@",result);
    int symble = [[result objectForKey:@"result"] integerValue];
    if (symble==1) {
        NSString *userId = [result objectForKey:@"userId"];
        [AppDelegate dLogInWithUserId:userId accountName:accoutName.text passWord:password.text];
        if (self.finishToPop) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
        MemberAreaViewController *viewController = [[MemberAreaViewController alloc] initWithNibName:@"MemberAreaViewController" bundle:nil];
        viewController.memberInfo = result;
        [self.navigationController pushViewController:viewController animated:YES];
        }
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"账号或密码错误" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"关闭", nil];
        [alertView show];
        
    }
    

}

- (IBAction)pushToReg:(id)sender {
    
    ReadRulerViewController *vc = [[ReadRulerViewController alloc] initWithNibName:@"ReadRulerViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
    
//    RegViewController *viewController = [[RegViewController alloc] initWithNibName:@"RegViewController" bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [myDiyTopBar setType:DiyTopBarTypeBack];
    myDiyTopBar.myTitle.text = @"会员登录";
    [myDiyTopBar.backButton setTitle:@"取消" forState:UIControlStateNormal];
    [myDiyTopBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    
    [txBgA setImage:[PicNameMc defaultBackgroundImage:@"inputBox@2x.png" size:txBgA.frame.size leftCapWidth:10 topCapHeight:10]];
    [txBgB setImage:[PicNameMc inputImagewithView:txBgB]];
    [iVA setImage:[[PicNameMc imageName:@"loginIcon@2x.png" numberOfH:2 numberOfW:1] objectAtIndex:0]];
    [iVB setImage:[[PicNameMc imageName:@"loginIcon@2x.png" numberOfH:2 numberOfW:1] objectAtIndex:1]];
    
    [logInButton setImage:[PicNameMc buttonBg:logInButton title:@"登录"] forState:UIControlStateNormal];

}
- (IBAction)bkTap:(id)sender {
    [self returnKeyBoard];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textFiel{
    [self returnKeyBoard];
    return YES;
}

-(void)returnKeyBoard{
    [accoutName endEditing:YES];
    [password endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    txBgA = nil;
    txBgB = nil;
    iVA = nil;
    iVB = nil;
    logInButton = nil;
    pushToRegButton = nil;
    accoutName = nil;
    password = nil;
    myDiyTopBar = nil;
    [super viewDidUnload];
}
@end
