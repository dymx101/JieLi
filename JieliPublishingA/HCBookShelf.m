//
//  HCBookShelf.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-16.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "HCBookShelf.h"
#import <QuartzCore/QuartzCore.h>

@implementation StateView

- (id)initWithFrame:(CGRect)frame viewType:(int)type{
    CGFloat width = frame.size.width;
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, width, k_STATE_VIEW_HEIGHT)];
    
    if (self) {
        //  设置当前视图类型
        self.viewType = type == k_VIEW_TYPE_HEADER ? k_VIEW_TYPE_HEADER : k_VIEW_TYPE_FOOTER;
        self.backgroundColor = [UIColor clearColor];
        
        //  初始化加载指示器（菊花圈）
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((k_STATE_VIEW_INDICATE_WIDTH - 20) / 2, (k_STATE_VIEW_HEIGHT - 20) / 2, 20, 20)];
        self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        self.indicatorView.hidesWhenStopped = YES;
        [self addSubview:self.indicatorView];
        
        //  初始化箭头视图
        self.arrowView = [[UIImageView alloc] initWithFrame:CGRectMake((k_STATE_VIEW_INDICATE_WIDTH - 32) / 2, (k_STATE_VIEW_HEIGHT - 32) / 2, 32, 32)];
        NSString * imageNamed = type == k_VIEW_TYPE_HEADER ? @"arrow_down.png" : @"arrow_up.png";
        self.arrowView.image = [UIImage imageNamed:imageNamed];
        [self addSubview:self.arrowView];
        
        //  初始化状态提示文本
        self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
        self.stateLabel.font = [UIFont systemFontOfSize:12.0f];
        self.stateLabel.backgroundColor = [UIColor clearColor];
        self.stateLabel.textAlignment = NSTextAlignmentCenter;
        self.stateLabel.text = type == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拖加载更多";
        [self addSubview:self.stateLabel];
        
        //  初始化更新时间提示文本
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, width, k_STATE_VIEW_HEIGHT - 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.text = @"-";
        [self addSubview:self.timeLabel];
    }
    return self;
}

- (void)changeState:(int)state{
    [self.indicatorView stopAnimating];
    self.arrowView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    switch (state) {
        case k_PULL_STATE_NORMAL:
            self.currentState = k_PULL_STATE_NORMAL;
            self.stateLabel.text = self.viewType == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拖加载更多";
            //  旋转箭头
            self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
        case k_PULL_STATE_DOWN:
            self.currentState = k_PULL_STATE_DOWN;
            self.stateLabel.text = @"释放刷新数据";
            self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case k_PULL_STATE_UP:
            self.currentState = k_PULL_STATE_UP;
            self.stateLabel.text = @"释放加载数据";
            self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            break;
            
        case k_PULL_STATE_LOAD:
            self.currentState = k_PULL_STATE_LOAD;
            self.stateLabel.text = self.viewType == k_VIEW_TYPE_HEADER ? @"正在刷新.." : @"正在加载..";
            [self.indicatorView startAnimating];
            self.arrowView.hidden = YES;
            break;
            
        case k_PULL_STATE_END:
            self.currentState = k_PULL_STATE_END;
            self.stateLabel.text = self.self.viewType == k_VIEW_TYPE_HEADER ? self.stateLabel.text : @"已加载全部数据";
            self.arrowView.hidden = YES;
            break;
            
        default:
            self.currentState = k_PULL_STATE_NORMAL;
            self.stateLabel.text = self.viewType == k_VIEW_TYPE_HEADER ? @"下拉可以刷新" : @"上拖加载更多";
            self.arrowView.layer.transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            break;
    }
    [UIView commitAnimations];
}

- (void)updateTimeLabel{
    NSDate * date = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:kCFDateFormatterFullStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    self.timeLabel.text = [NSString stringWithFormat:@"更新于 %@", [formatter stringFromDate:date]];
}

- (void)dealloc{
    [super dealloc];
    self.indicatorView = nil;
    self.arrowView = nil;
    self.stateLabel = nil;
    self.timeLabel = nil;
}

@end




#import "PicNameMc.h"
#import "DataBrain.h"

typedef enum {
    ItemOrgainX = 36/2,
    ItemOrgainY = 46/2-20,
    ItemWith = 160/2,
    ItemHeigh = 232/2,
    PaddingRight = 18,
    PaddingTop = 50,
}ItemRect;



@implementation HCBookShelf
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return nil;
}

-(void)awakeFromNib{
    self.bounces = YES;
    self.scrollEnabled = YES;
    self.alwaysBounceHorizontal = NO;
    self.alwaysBounceVertical = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showPrice = YES;
    self.delegate = self;
}


-(NSMutableArray *)imagesStack {
    if (!_imagesStack) {
        _imagesStack = [[NSMutableArray alloc] init];
    }
    return _imagesStack;
}


-(void)reloadData{
    NSLog(@"重新加载书架");
    int lastItenCount = self.itemCount;
    self.itemCount = [self.dataSource numberOfItemsForShell:self];
//    if (lastItenCount >= self.itemCount) {
        for (int i =0; i<lastItenCount; i++) {
            BookView *bookView = (BookView *)[self viewWithTag:BookViewTag +i];
            [bookView removeFromSuperview];
            
            if (i%3==0&&self.showPrice) {
                UIImageView *priceBg = (UIImageView *)[self viewWithTag:PriceBgTag+i];
                [priceBg removeFromSuperview];
            }

        }
//    }
    
    int xPos = ItemOrgainX;
    int yPos = ItemOrgainY;
    for (int i = 0; i < self.itemCount; i++) {
        BookView *bookView = [self.dataSource bookViewForIndex:i];
        bookView.tag = BookViewTag +i;
//        bookView.center = CGPointMake(xPos+ItemWith/2, yPos+ItemHeigh/2);
        bookView.frame = CGRectMake(xPos, yPos, bookView.frame.size.width, bookView.frame.size.height);
        bookView.delegate = self;
        [self addSubview:bookView];

        if (i%3==0&&self.showPrice) {
            UIImage *image = [PicNameMc imageFromImageName:_image_priceBg];
            UIImageView *priceBg = [[UIImageView alloc] initWithImage:image];
            priceBg.frame = CGRectMake(0, yPos+155, image.size.width,image.size.height);
            priceBg.tag =PriceBgTag+ i;
            [self insertSubview:priceBg belowSubview:bookView];
        }

        
        
        xPos +=ItemWith;
        xPos +=PaddingRight;
        if ((i+1)%3 == 0) {
            xPos = ItemOrgainX;
            yPos +=ItemHeigh;
            yPos +=PaddingTop;
        }
        

    }
    
    
    if (self.itemCount%3!=0) {
        yPos +=ItemHeigh;
        yPos +=PaddingTop;

    }
    self.contentSize = CGSizeMake(0, yPos);
//    [self setContentOffset:CGPointMake(0, 0) animated:YES];
//    [self layoutSubviews];
    [self.footerView setCenter:CGPointMake(160, self.contentSize.height+15)];

}
#pragma mark-
#pragma BookViewDelegate
-(void)bookViewBeTouched:(BookView*)bookView{
    if ([self.itemSelectedDelegate respondsToSelector:@selector(bookShellk:itemSelectedAtIndex:)]) {
        [self.itemSelectedDelegate bookShellk:self itemSelectedAtIndex:bookView.tag-BookViewTag];

    }
}
-(void)bookViewBeDelete:(BookView *)bookView{
    if ([self.itemSelectedDelegate respondsToSelector:@selector(bookshelf:deleteAtIndex:)]) {
        [self.itemSelectedDelegate bookshelf:self deleteAtIndex:bookView.tag - BookViewTag];
        
    }
}

-(void)updateData{
    
}



-(StateView*)headerView{
    if (!_headerView) {
        _headerView = [[StateView alloc] initWithFrame:CGRectMake(0, -40, self.frame.size.width, self.frame.size.height) viewType:k_VIEW_TYPE_HEADER];
        [self addSubview:_headerView];
    }
    return _headerView;
}

-(StateView*)footerView{
    if (!_footerView) {
        _footerView = [[StateView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) viewType:k_VIEW_TYPE_FOOTER];
        [self addSubview:_footerView];
    }
    [_footerView setCenter:CGPointMake(160, self.contentSize.height+15)];
    return _footerView;
}

#pragma mark -
#pragma mark scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = self.contentOffset.y;
    //  判断是否正在加载
    if (self.headerView.currentState == k_PULL_STATE_LOAD ||
        self.footerView.currentState == k_PULL_STATE_LOAD) {
        return;
    }
    //  改变“下拉可以刷新”视图的文字提示
    if (offsetY < -k_STATE_VIEW_HEIGHT ) {
        [self.headerView changeState:k_PULL_STATE_DOWN];
    } else {
        [self.headerView changeState:k_PULL_STATE_NORMAL];
    }
    //  判断数据是否已全部加载
    if (self.footerView.currentState == k_PULL_STATE_END) {
        return;
    }
    //  计算表内容大小与窗体大小的实际差距
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    //  改变“上拖加载更多”视图的文字提示
    if (offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
        [self.footerView changeState:k_PULL_STATE_UP];
    } else {
        [self.footerView changeState:k_PULL_STATE_NORMAL];
    }


}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (self.headerView.hidden) {
        return;
    }

    CGFloat offsetY = self.contentOffset.y;
    NSInteger returnKey = k_RETURN_DO_NOTHING;
;
    //  判断是否正在加载数据
    if (self.headerView.currentState == k_PULL_STATE_LOAD ||
        self.footerView.currentState == k_PULL_STATE_LOAD) {
        returnKey = k_RETURN_DO_NOTHING;
        return;
    }
    //  改变“下拉可以刷新”视图的文字及箭头提示
    if (offsetY < -k_STATE_VIEW_HEIGHT ) {
        [self.headerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsMake(-offsetY, 0, 0, 0);
         returnKey = k_RETURN_REFRESH;
    }
    //  改变“上拉加载更多”视图的文字及箭头提示
    CGFloat differenceY = self.contentSize.height > self.frame.size.height ? (self.contentSize.height - self.frame.size.height) : 0;
    if (self.footerView.currentState != k_PULL_STATE_END &&
        offsetY > differenceY + k_STATE_VIEW_HEIGHT / 3 * 2) {
        [self.footerView changeState:k_PULL_STATE_LOAD];
        self.contentInset = UIEdgeInsetsMake(0, 0, offsetY - differenceY, 0);

         returnKey = k_RETURN_LOADMORE;
    }
    
    if (returnKey != k_RETURN_DO_NOTHING) {
        NSString * key = [NSString stringWithFormat:@"%d", returnKey];
        [NSThread detachNewThreadSelector:@selector(updateThread:) toTarget:self withObject:key];
    }
}

- (void)updateThread:(NSString *)returnKey{
//    sleep(2);
    switch ([returnKey intValue]) {
        case k_RETURN_REFRESH:
            self.headerView.currentState = k_PULL_STATE_LOAD;
            [self.itemSelectedDelegate refreshUpdate];
            break;
            
        case k_RETURN_LOADMORE:
            self.headerView.currentState = k_PULL_STATE_LOAD;
            [self.itemSelectedDelegate loadMoreUpdate];
            break;
        default:
            break;
    }
//    [self performSelectorOnMainThread:@selector(updateTableView) withObject:nil waitUntilDone:NO];
}

@end
