//
//  GeedBackViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-2-26.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "GeedBackViewController.h"

@interface GeedBackViewController ()

@end

@implementation GeedBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.diyTopBar.myTitle.text = @"意见反馈";
    [self.diyTopBar setType:DiyTopBarTypeBackAndCollect];
    [self.diyTopBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self.diyTopBar.collectButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.diyTopBar.collectButton addTarget:self action:@selector(faSong) forControlEvents:UIControlEventTouchUpInside];
    
}
static NSString *text = nil;
-(void)faSong{
    NSString *avTitle = @"发送成功";
    if (![self.textView.text length]) {
        avTitle = @"内容不能为空";
    }
    else{
        if (text && [text isEqualToString:self.textView.text]) {
            avTitle = @"请不要重复发送同样的内容";
        }
        else{
            text = [self.textView.text copy];
        }
    }
    
    [self.textView resignFirstResponder];
    [self.textFildA resignFirstResponder];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"意见反馈" message:avTitle delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [av show];
}
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self.textFildA setPlaceholder:@""];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.textView.text length]==0) {
        [self.textFildA setPlaceholder:@"请输入您的意见反馈"];

    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];

    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setDiyTopBar:nil];
    [self setTextFildA:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}
@end
