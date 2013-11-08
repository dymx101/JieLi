//
//  BookCertificateViewController.m
//  JieLiShelf
//
//  Created by HuaChen on 13-10-31.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "BookCertificateViewController.h"
#import "DiyTopBar.h"
#import "BasicOperation.h"
#import "AppDelegate.h"

@interface BookCertificateViewController ()
@property (retain, nonatomic) IBOutlet DiyTopBar *myDiyBar;
@property (nonatomic,strong) id bookCList;
@property (nonatomic,strong) NSString *bookC;

@property (nonatomic,strong) id un_usedList;
@property (nonatomic,strong) id usedList;
@end

@implementation BookCertificateViewController

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
    
    [self.myDiyBar setType:DiyTopBarTypeBack];
    [self.myDiyBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    [self.myDiyBar.myTitle setText:@"兑换码"];

    BasicOperation *bo = [BasicOperation basicOperationWithUrl:@"?c=Member&m=getBookCertificateList" withTaget:self select:@selector(finishGetBookCertificateList:)];
//    [[AppDelegate shareQueue] addOperation:bo];
    [bo start];
    
    [self getOwnC];
}

-(void)finishGetBookCertificateList:(id)r{
    self.bookCList = r;
    NSLog(@"%@",r);
    [self.tabelView reloadData];
    
}

-(void)getOwnC{
    BasicOperation *bo = [BasicOperation basicOperationWithUrl:[NSString stringWithFormat:@"?c=Member&m=getBookExchange_user&user_id=%@",[AppDelegate dUserId]] withTaget:self select:@selector(finishgetOwnC:)];
    [bo start];
}
-(void)finishgetOwnC:(id)r{
    self.un_usedList = [r objectForKey:@"exchange_un"];
    self.usedList = [r objectForKey:@"exchange_ed"];
    NSLog(@"%@",r);
    [self.tabelView reloadData];

}




-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;

}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"领取兑换码";
            break;
        case 1:
            return @"未使用的兑换码";
            break;
        case 2:
            return @"已使用的兑换码";
            break;
        default:
            return nil;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return [self.bookCList count];
            break;
        case 1:
            return [self.un_usedList count];
            break;
        case 2:
            return [self.usedList count];
            break;
        default:
            return nil;
            break;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            NSDictionary *dic = [self.bookCList objectAtIndex:indexPath.row];
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 81)];
            [cell.textLabel setText:[NSString stringWithFormat:@"点击兑换%@元代金券，消耗积分%@",[dic objectForKey:@"value"],[dic objectForKey:@"score"]]];
            self.bookC = [dic objectForKey:@"num_id"];
            return cell;
        }
            break;
        case 1:{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 81)];
            [cell.textLabel setText:[self.un_usedList objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        case 2:{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 81)];
            [cell.textLabel setText:[self.usedList objectAtIndex:indexPath.row]];
            return cell;
        }
            break;
        default:
            break;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 81)];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
            case 0:
        {
            UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"兑换码" message:@"您将消耗一定积分获得一个兑换码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alv.tag = 1000;
            [alv show];
        }
            break;
            default:
                break;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            BasicOperation *bo = [BasicOperation basicOperationWithUrl:[NSString stringWithFormat:@"?c=Member&m=getByBookExchange&user_id=%@&exchange_id=%@",[AppDelegate dUserId],self.bookC] withTaget:self select:@selector(finishGetBookC:)];
            [bo start];
        }
    }
}
-(void)finishGetBookC:(id)r{
    NSLog(@"%@",r);
    int result = [[r objectForKey:@"result"] intValue];
    
    NSString *title = nil;
    if (result) {
        title = @"兑换成功";
        [self getOwnC];
    }
    else{
        title = @"兑换失败";
    }
    
    NSString *message = [r objectForKey:@"message"];
    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    alv.tag = 1001;
    [alv show];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_myDiyBar release];
    [_tabelView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMyDiyBar:nil];
    [self setTabelView:nil];
    [super viewDidUnload];
}
@end
