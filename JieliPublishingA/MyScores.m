//
//  MyScores.m
//  JieLiShelf
//
//  Created by HuaChen on 13-10-22.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "MyScores.h"
#import "BasicOperation.h"
@implementation MyScores

-(void)loadInfo:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    NSString *accountName = [dic objectForKey:@"userName"];
    NSString *scores = [dic objectForKey:@"score"];
    
    self.accuntLable.text = [self.accuntLable.text stringByAppendingString:accountName];
    self.scoreLable.text = [self.scoreLable.text stringByAppendingString:scores];
    self.user_id = [dic objectForKey:@"userId"];
}


- (IBAction)scroeRule:(id)sender {
    [self.myScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    [self bringSubviewToFront:self.ruleScrollView];
    self.ruleScrollView.hidden = NO;
    self.detailTableView.hidden = YES;
}
- (IBAction)ruleBack:(id)sender {
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (IBAction)scoreDetail:(id)sender {
    
    BasicOperation *bo = [BasicOperation basicOperationWithUrl:[NSString stringWithFormat:@"?c=Activity&m=getScoreDetail&user_id=%@",self.user_id] withTaget:self select:@selector(finishLoadDetail:)];
    [bo start];
}
- (IBAction)detailBack:(id)sender {
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}

-(void)finishLoadDetail:(id)r{
    [self.myScrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    [self bringSubviewToFront:self.detailTableView];
    self.detailTableView.hidden = NO;
    self.ruleScrollView.hidden = YES;
    
    self.details = nil;
    self.details = [[NSMutableArray alloc] initWithArray:[r objectForKey:@"detail"]];
    [self.detailTableView reloadData];
    
}
#pragma mark-- tabelView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.details count]+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

static int la = 100;
static int lb = 50;
static int hi = 40;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    if (indexPath.row == 0) {
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, la, hi)];
        timeL.text = @"时间";
        [timeL setBackgroundColor:[UIColor clearColor]];
        [timeL setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:timeL];
        
        UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(la, 0, 320-la-lb, hi)];
        noteL.text = @"积分说明";
        [noteL setBackgroundColor:[UIColor clearColor]];
        [noteL setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:noteL];

        UILabel *scoreL = [[UILabel alloc] initWithFrame:CGRectMake(320-lb-5, 0, lb, hi)];
        scoreL.text = @"分值";
        [scoreL setBackgroundColor:[UIColor clearColor]];
        [scoreL setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:scoreL];
    }
    else{
        NSDictionary *dic = [self.details objectAtIndex:indexPath.row -1];
        UILabel *timeL = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, la, hi)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        //用[NSDate date]可以获取系统当前时间
        NSString *DateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"ctime"] integerValue]]];

        timeL.text = DateStr;
        [timeL setBackgroundColor:[UIColor clearColor]];
        [timeL setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:timeL];
        
        UILabel *noteL = [[UILabel alloc] initWithFrame:CGRectMake(la, 0, 320-la-lb, hi)];
        noteL.text = [dic objectForKey:@"memo"];
        [noteL setBackgroundColor:[UIColor clearColor]];
        [noteL setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:noteL];
        
        UILabel *scoreL = [[UILabel alloc] initWithFrame:CGRectMake(320-lb-5, 0, lb, hi)];
        scoreL.text = [self scoreFromeSnum:[dic objectForKey:@"snum"]];
        [scoreL setBackgroundColor:[UIColor clearColor]];
        [scoreL setTextAlignment:NSTextAlignmentCenter];
        [cell addSubview:scoreL];

        
    }
    UIImageView *giv1 = [[UIImageView alloc] initWithFrame:CGRectMake(la, 2, 2, hi-3)];
    [giv1 setBackgroundColor:[UIColor lightGrayColor]];
    
    UIImageView *giv2 = [[UIImageView alloc] initWithFrame:CGRectMake(320-lb, 2, 2, hi-3)];
    [giv2 setBackgroundColor:[UIColor lightGrayColor]];
    
    [cell addSubview:giv1];
    [cell addSubview:giv2];

    return cell;

}

-(NSString *)scoreFromeSnum:(NSString *)snum{
    int s = [snum intValue];
    int rs = 0;
    switch (s) {
        case 1001:
            rs = 50;
            break;
        case 1002:
            rs = 10;
            break;
        case 2001:
            rs = 1;
            break;
        case 2002:
            rs = 2;
            break;
        case 2003:
            rs = 2;
            break;
        case 2004:
            rs = 2;
            break;
        case 2005:
            rs = 10;
            break;
        default:
            break;
    }
    return [NSString stringWithFormat:@"%d",rs];
}
-(void)awakeFromNib{
    [self.ruleScrollView setContentSize:CGSizeMake(0, 897)];
//    self.detailTableView.hidden = YES;
//    self.ruleScrollView.hidden = YES;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_myScrollView release];
    [_ruleScrollView release];
    [_detailTableView release];
    [_accuntLable release];
    [_scoreLable release];
    [super dealloc];
}
@end
