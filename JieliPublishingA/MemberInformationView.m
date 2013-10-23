//
//  MemberInformationView.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-2-1.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "MemberInformationView.h"
#import <QuartzCore/QuartzCore.h>
#import "PicNameMc.h"
#import "AppDelegate.h"
#define ButtonTag 1000
@interface MemberInformationView(){
    NSString *sexbb;
}
@end

@implementation MemberInformationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    [self.birthdayPicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    self.birthdaySureButton.hidden = YES;
    
    [self.birthdaySureButton setImage:[PicNameMc defaultBackgroundImage:@"gb" withWidth:self.birthdaySureButton.frame.size.width withTitle:@"确定" withColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.editEnd setImage:[PicNameMc defaultBackgroundImage:@"gb" withWidth:self.editEnd.frame.size.width withTitle:@"完成编辑" withColor:[UIColor blackColor]] forState:UIControlStateNormal];
    [self.postInfo setImage:[PicNameMc defaultBackgroundImage:@"gb" withWidth:self.postInfo.frame.size.width withTitle:@"提交修改" withColor:[UIColor blackColor]] forState:UIControlStateNormal];
    
    [self.disLogButton setImage:[PicNameMc grayBg:self.disLogButton title:@"注销"] forState:UIControlStateNormal];

    
    sexbb = @"0";

}
- (IBAction)disLog:(id)sender {
    [AppDelegate dLogOut];
    [self.partentViewController.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)sexSelected:(id)sender {
    UIButton *btn = (UIButton *)sender;
    sexbb = [[NSString alloc] initWithFormat:@"%d",btn.tag-ButtonTag];
    
    for (int i = 0; i<3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+ButtonTag];
//        if (![button isKindOfClass:[UIButton class]]) {
//            continue;
//        }
        if (i == btn.tag-ButtonTag) {
            button.selected = YES;
            
        }
        else{
            button.selected = NO;
        }
    }

    
}


-(void)setText:(NSString *)string withLabel:(UILabel *)label{
    if (![string length]) {
        string = @"未设置";
    }
        label.text = string;
}
-(void)showInformationWith:(NSDictionary *)dic{
    if (!dic) {
        return;
    }
    NSString *string;
    string = [dic objectForKey:@"alias"];
    [self setText:string withLabel:self.nikName];
    string = [dic objectForKey:@"sex"] ;
    int a = [string intValue];
    switch (a) {
        case 0:
            string = @"保密";
            break;
        case 1:
            string = @"男";
            break;
        case 2:
            string = @"女";
            break;
            
        default:
            break;
    }
    [self setText:string withLabel:self.sex];
    string = [dic objectForKey:@"birthday"];
    [self setText:string withLabel:self.bornDay];
    string = [dic objectForKey:@"email"];
    [self setText:string withLabel:self.mail];
    string = [dic objectForKey:@"job"];
    [self setText:string withLabel:self.profession];
    string = [dic objectForKey:@"userName"];
    if (string&&[string length]) {
        [self setText:string withLabel:self.memberName];
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"userName"];
    }
    string = [dic objectForKey:@"password"];
    if (string&&[string length]) {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"password"];

    }
    string = [dic objectForKey:@"userId"];
    if (string&&[string length]) {
        [[NSUserDefaults standardUserDefaults] setObject:string forKey:@"userId"];
    }
//
    [self showEditInformationView:dic];

    
}
-(void)showEditInformationView:(NSDictionary *)dic{
    NSString *str;
    str = [[NSUserDefaults standardUserDefaults] stringForKey:@"userName"];
    [self setText:str withLabel:self.memberNameEdit];

    str = [dic objectForKey:@"alias"];
    self.nikNameEdit.text = str;
    str = [dic objectForKey:@"birthday"];
    self.borthDayEdit.text = str;
    str = [dic objectForKey:@"email"];
    self.mailEdit.text = str;
    str = [dic objectForKey:@"job"];
    self.professionEdit.text = str;
    
    str = [dic objectForKey:@"sex"] ;
    int a = [str intValue];
    for (int i = 0; i<3; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+ButtonTag];
//        if (![button isKindOfClass:[UIButton class]]) {
//            continue;
//        }

        if (i == a) {
            button.selected = YES;

        }
        else{
            button.selected = NO;
        }
    }
    
}
-(void)back{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(-320,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [UIView commitAnimations];

}
- (IBAction)editButtonTouched:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(0,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    [UIView commitAnimations];

}
- (IBAction)finishEdit:(id)sender {
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    NSString *email = self.mailEdit.text;
    NSString *sex = @"0";
    if (sexbb) {
        sex = sexbb;
    }
    NSString *birthday = self.borthDayEdit.text;
    NSString *alias = self.nikNameEdit.text;
    NSString *qq = @"";
    NSString *phone = @"";
    NSString *job = self.professionEdit.text;
    NSString *avater = self.nikNameEdit.text;
    NSString *urlString = [NSString stringWithFormat:@"?c=Member&m=userInfoUpdate&userId=%@&email=%@&sex=%@&birthday=%@&alias=%@&qq=%@&phone=%@&job=%@&avater=%@",userId,email,sex,birthday,alias,qq,phone,job,avater];
    
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            NSDictionary *result =[NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:&error];
            NSLog(@"修改个人信息：%@",result);
            //            NSLog(@"获取促销优惠列表成功。");
            //            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            //            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(changSuccess:) withObject:result waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];

    
    
}
-(void)changSuccess:(NSDictionary *)dic{
    [self showInformationWith:dic];
    [self back];

}
- (IBAction)changePassWordTouched:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(-640,44,self.frame.size.width,self.frame.size.height);
    [UIView commitAnimations];

}

- (IBAction)finishChange:(id)sender {
    NSString *meg;
    NSString *oldPassword =[[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    if (![oldPassword isEqualToString:self.oldPassWord.text]) {
        meg = @"原始密码错误";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改失败" message:meg delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"关闭", nil];
        
        [alertView show];
        return;

    }
    if (![self.aNewPassWord.text isEqualToString:self.againNewPassWord.text]) {
        meg = @"两次输入密码不一致";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改失败" message:meg delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"关闭", nil];
        [alertView show];
        return;
    }
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];

    NSString *urlString = [NSString stringWithFormat:@"?c=Member&m=resetPsw&userId=%@&oldPsw=%@&newPsw=%@",userId,oldPassword,self.aNewPassWord.text];
    
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            NSDictionary *result =[NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions error:&error];
            NSLog(@"修改密码：%@",result);
            //            NSLog(@"获取促销优惠列表成功。");
            //            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            //            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(changPassWordSuccess:) withObject:result waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];
   
}
-(void)changPassWordSuccess:(NSDictionary *)dic{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"修改成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag = 10;
    [alertView show];

}
#pragma mark-
#pragma alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if (alertView.tag ==10) {
                [self back];
            }
            break;
        case 1:
             [self back];
            break;
        default:
            break;
    }
}


- (IBAction)endBirthday:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.3f];
    self.editView.frame = CGRectMake(self.editView.frame.origin.x, self.editView.frame.origin.y+40, self.editView.frame.size.width, self.editView.frame.size.height);
    self.birthdayPicker.frame = CGRectMake(0, 380, 320, self.birthdayPicker.frame.size.height);
    [UIView commitAnimations];
    self.birthdaySureButton.hidden = YES;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //    CGRect winRect = [[UIScreen mainScreen] bounds];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.3f];
//    self.frame = CGRectMake(0, 64, self.frame.size.width, self.frame.size.height);
//    [UIView commitAnimations];
    if(textField.tag ==3){
        if (![self validateEmail:textField.text]) {
            NSLog(@"请输入合法的email地址");
            UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"请输入合法的email地址" message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [ale show];
            return NO;
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.editView.frame = CGRectMake(self.editView.frame.origin.x, self.editView.frame.origin.y+80, self.editView.frame.size.width, self.editView.frame.size.height);
        [UIView commitAnimations];
    }
    else if(textField.tag ==4){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.editView.frame = CGRectMake(self.editView.frame.origin.x, self.editView.frame.origin.y+120, self.editView.frame.size.width, self.editView.frame.size.height);
        [UIView commitAnimations];
    }

    [textField endEditing:YES];

    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag == 2) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.editView.frame = CGRectMake(self.editView.frame.origin.x, self.editView.frame.origin.y-40, self.editView.frame.size.width, self.editView.frame.size.height);
        self.birthdayPicker.frame = CGRectMake(0, 164, 320, self.birthdayPicker.frame.size.height);
        [UIView commitAnimations];
        self.birthdaySureButton.hidden = NO;
        return NO;
    }
    else if(textField.tag ==3){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.editView.frame = CGRectMake(self.editView.frame.origin.x, self.editView.frame.origin.y-80-30, self.editView.frame.size.width, self.editView.frame.size.height);
        [UIView commitAnimations];
    }
    else if(textField.tag ==4){
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.3f];
        self.editView.frame = CGRectMake(self.editView.frame.origin.x, self.editView.frame.origin.y-120, self.editView.frame.size.width, self.editView.frame.size.height);
        [UIView commitAnimations];
    }


    return YES;
}
-(void)dateChanged:(id)sender{
    UIDatePicker* control = (UIDatePicker*)sender;
    NSDate* _date = control.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:_date];
    self.borthDayEdit.text = currentDateStr;
    
    /*添加你自己响应代码*/
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.3f];
//    self.frame = CGRectMake(0,44,self.frame.size.width,self.frame.size.height);
//    [UIView commitAnimations];
//    if (textField.tag==2) {
    
}// became first responder
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called

@end
