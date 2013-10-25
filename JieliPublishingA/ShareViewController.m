//
//  ShareViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "ShareViewController.h"
#import "BasicOperation.h"
@interface ShareViewController (){
    NSDictionary *userInfo;
    NSArray *statuses;
    NSString *postStatusText;
    

    IBOutlet WeiBoBar *sinaWeiBoBar;
    IBOutlet WeiBoBar *tenWeiBoBar;
    IBOutlet WeiBoBar *weiXinBar;
}

@end

@implementation ShareViewController

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
    [ShareSDK ssoEnabled:NO];

    CGRect frameSina = sinaWeiBoBar.frame;
    [sinaWeiBoBar removeFromSuperview];
    sinaWeiBoBar = nil;
    CGRect frameTeng = tenWeiBoBar.frame;
    [tenWeiBoBar removeFromSuperview];
    tenWeiBoBar = nil;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeiBoBar" owner:self options:nil];
    sinaWeiBoBar = [nib objectAtIndex:0];
    sinaWeiBoBar.weiBoStyle = KeyStyleOfSina;
    sinaWeiBoBar.delegate = self;
//    [sinaWeiBoBar setTextWithLogeIn:@"绑定新浪微博" withShare:@"分享至新浪微博"];
    [sinaWeiBoBar setImageU:[UIImage imageNamed:@"F_image_share_sina"] setImageB:[UIImage imageNamed:@"F_image_share_sinaB"]];
    
    NSArray *nibt = [[NSBundle mainBundle] loadNibNamed:@"WeiBoBar" owner:self options:nil];
    tenWeiBoBar = [nibt objectAtIndex:0];
    tenWeiBoBar.weiBoStyle = KeyStyleofTen;
    tenWeiBoBar.delegate = self;
//    [sinaWeiBoBar setTextWithLogeIn:@"绑定新浪微博" withShare:@"分享至新浪微博"];
    [tenWeiBoBar setImageU:[UIImage imageNamed:@"F_image_share_teng"] setImageB:[UIImage imageNamed:@"F_image_share_tengB"]];
    
    NSArray *nibw = [[NSBundle mainBundle] loadNibNamed:@"WeiBoBar" owner:self options:nil];
    weiXinBar = [nibw objectAtIndex:0];
    weiXinBar.weiBoStyle = KEyStyleOfWeiXin;
    weiXinBar.delegate = self;
    //    [sinaWeiBoBar setTextWithLogeIn:@"绑定新浪微博" withShare:@"分享至新浪微博"];
//    [tenWeiBoBar setImageU:[UIImage imageNamed:@"F_image_share_teng"] setImageB:[UIImage imageNamed:@"F_image_share_tengB"]];


    id<ISSCredential> sinaC = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];
    
    if ([sinaC available]) {
        NSLog(@"sina 授权状态");
        [sinaWeiBoBar setState:ShareState];
        [sinaWeiBoBar checkSelected];
    }
    else{
        NSLog(@"sina 非授权状态");
        [sinaWeiBoBar setState:LogInState];
    }
    id<ISSCredential> tenC = [ShareSDK getCredentialWithType:ShareTypeTencentWeibo];
    if ([tenC available]) {
        NSLog(@"ten 授权状态");
        [tenWeiBoBar setState:ShareState];
        [tenWeiBoBar checkSelected];

    }
    else{
        NSLog(@"ten 非授权状态");
        [tenWeiBoBar setState:LogInState];

    }


    sinaWeiBoBar.frame = frameSina;
    [self.view addSubview:sinaWeiBoBar];
    
    tenWeiBoBar.frame = frameTeng;
    [self.view addSubview:tenWeiBoBar];

    
}
-(void)loadBookInfo:(BookInfo *)info{
    NSString *text = [NSString stringWithFormat:@"test -- date:%@  bookName:%@",[NSDate new],info.bookName];
    [self.textView setText:text];
    
    self.sendImage =  [UIImage imageWithData:[DataBrain readFilewithImageId:info.bookId withFlolderName:BookCoverImage]];

}

-(void)logInWithWerboBar:(WeiBoBar *)weiBoBar{
    if ([weiBoBar.weiBoStyle isEqualToString:KeyStyleOfSina]) {
        [self shouQuan:ShareTypeSinaWeibo];
    }
    else if([weiBoBar.weiBoStyle isEqualToString:KeyStyleofTen]){
        [self shouQuan:ShareTypeTencentWeibo];
    }
}




- (void)sendWeiBo{
    if (sinaWeiBoBar.isSelected) {
        [self sendShare:ShareTypeSinaWeibo];
    }
    if (tenWeiBoBar.isSelected) {
        [self sendShare:ShareTypeTencentWeibo];
    }
}
-(void)shouQuan:(ShareType)type{
    UIButton *iv = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    iv.backgroundColor = [UIColor redColor];
//    iv.alpha = 0.4;
//    iv.userInteractionEnabled = NO;
    [self.view.superview.superview addSubview:iv];
    
    id<ISSAuthOptions> op = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStylePopup viewDelegate:nil authManagerViewDelegate:nil];
    
    [ShareSDK authWithType:type options:op result:^(SSAuthState state, id<ICMErrorInfo> error) {
        if (state == SSAuthStateSuccess)
        {
            NSLog(@"成功");
            switch (type) {
                case ShareTypeSinaWeibo:
                    [sinaWeiBoBar setState:ShareState];
                    break;
                case ShareTypeTencentWeibo:
                    [tenWeiBoBar setState:ShareState];
                    break;
                default:
                    break;
            }
        }
        else if (state == SSAuthStateFail)
        {
            NSLog(@"失败");
            switch (type) {
                case ShareTypeSinaWeibo:
                    [sinaWeiBoBar setState:LogInState];
                    break;
                case ShareTypeTencentWeibo:
                    [tenWeiBoBar setState:LogInState];
                    break;
                default:
                    break;
            }

        }
        else if (state == SSAuthStateCancel){
            NSLog(@"取消");
            [iv removeFromSuperview];
        }
    }];
    
    

}
-(void)sendShare:(ShareType)type{
    
    
    NSString *sendMessage = self.textView.text;
    UIImage *sendImage = self.sendImage;

    //创建分享内容
    
    id<ISSContent> publishContent = [ShareSDK content:sendMessage
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:sendImage quality:1]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
    
    id<ISSAuthOptions> op = [ShareSDK authOptionsWithAutoAuth:YES allowCallback:NO authViewStyle:SSAuthViewStylePopup viewDelegate:nil authManagerViewDelegate:nil];
    
    
    [ShareSDK shareContent:publishContent
                      type:type
               authOptions:op
             statusBarTips:YES
                    result:^(ShareType type, SSPublishContentState state, id<ISSStatusInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                            NSString *url = nil;
                            if (self.bookId) {
                                url =[NSString stringWithFormat:@"?c=Member&m=shareBook&user_Id=%@&book_Id=%@",[AppDelegate dUserId],self.bookId];
                                BasicOperation *bo = [BasicOperation basicOperationWithUrl:url withTaget:nil select:nil];
                                [bo start];

                            }
                            else if(self.eventId){
                                url =[NSString stringWithFormat:@"?c=Member&m=shareEvent&user_Id=%@&event_Id=%@",[AppDelegate dUserId],self.eventId];
                                BasicOperation *bo = [BasicOperation basicOperationWithUrl:url withTaget:self select:@selector(finishShareEvent)];
                                [bo start];

                            }
                            

                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                        }
                    }];
    
}

-(void)finishShareEvent{
    [self.delegate ShareEventSuccess];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTextView:nil];
    sinaWeiBoBar = nil;
    [tenWeiBoBar release];
    tenWeiBoBar = nil;
    [weiXinBar release];
    weiXinBar = nil;
    [super viewDidUnload];
}
- (void)dealloc {
    [tenWeiBoBar release];
    [weiXinBar release];
    [super dealloc];
}
@end
