//
//  CommentCell.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-29.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "CommentCell.h"
#import "PicNameMc.h"
#import <QuartzCore/QuartzCore.h>


@implementation CommentCell

+(CommentCell *)cellFromCell:(CommentCell*)originCell{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
    CommentCell *cell = [nibs objectAtIndex:0];
//    cell.userName.text = originCell.userName.text;
//    cell.content.text = originCell.content.text;
    cell.frame = originCell.frame;
    cell.isHigher = originCell.isHigher;
    [cell loadData:originCell.cellDic];

    
    return cell;

}

+(NSMutableArray *)cellsForData:(NSArray *)arrayData{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in arrayData) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
        CommentCell *cell = [nibs objectAtIndex:0];
        [cell loadData:dic];
        [array addObject:cell];
    }
    return array;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.isHigher = !self.isHigher;
    }
}

-(void)reSetContentLabel{
    CGSize labelSize = [self.content.text sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                     constrainedToSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT)
                                         lineBreakMode:UILineBreakModeCharacterWrap];
    NSLog(@"%f,%f",self.content.frame.origin.y,labelSize.height);
    if (labelSize.height<self.content.frame.size.height) {
        [self loadBackGroundView];
        return;
    }

    if (self.isHigher) {
        
        [self.content setFrame:CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.content.frame.size.width, labelSize.height)];
        NSLog(@"%f",self.content.frame.origin.y);
        
    }
    else{

        [self.content setFrame:CGRectMake(self.content.frame.origin.x, self.content.frame.origin.y, self.content.frame.size.width, 68)];
    }
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width, self.content.frame.origin.y+self.content.frame.size.height+10)];
    [self loadBackGroundView];


}
-(void)loadBackGroundView{
    CGRect inRect = CGRectInset(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), 5, 5);
    
    UIGraphicsBeginImageContextWithOptions(inRect.size, NO, 0.);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(currentContext,CGRectMake(0, 0, inRect.size.width, inRect.size.height));
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.frame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:resultImage];
    
    //    [imageView.layer setShadowColor:[UIColor blackColor].CGColor];
    //    [imageView.layer setShadowOffset:CGSizeMake(-3, 3)];
    //    [imageView.layer setShadowRadius:8];
    //    [imageView.layer setShadowOpacity:0.5];
    
    [imageView.layer setCornerRadius:8];
    [imageView.layer setMasksToBounds:YES];
    imageView.frame = inRect;
    [backgroundImageView addSubview:imageView];
    [self setBackgroundView:backgroundImageView];
    resultImage = nil;
    imageView = nil;
    backgroundImageView = nil;

}
-(void)loadData:(NSDictionary *)dic{
    NSLog(@"%@",dic);
    
    self.cellDic = [NSDictionary dictionaryWithDictionary:dic];
    int starNumber = [[dic objectForKey:@"comment_rank"] intValue];
    for (int i = 0; i<5; i++) {
        NSString *starName ;
        if (i<starNumber) {
            starName = @"star";
        }
        else{
            starName = @"emptyStar";
        }
        UIImage *image = [UIImage imageNamed:starName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(20+20*i , 10 , 36/2, 32/2);
        [self addSubview:imageView];        
    }
    NSString *userName_ =[dic objectForKey:@"userName"];
    if (!userName_||[userName_ isEqualToString:@"(null)"]) {
        userName_ = @"匿名";
    }
    [self.userName setText:userName_];
    [self.content setText:[dic objectForKey:@"content"]];
    [self.content setFont:[UIFont systemFontOfSize:14.f]];
    [self.content setNumberOfLines:0];
    [self.content setLineBreakMode:UILineBreakModeCharacterWrap];
//    [self.content setBackgroundColor:[UIColor redColor]];
    [self reSetContentLabel];

}

- (void)dealloc {
    [_userName release];
    [_content release];
    [super dealloc];
}
@end
