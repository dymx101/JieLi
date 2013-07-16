//
//  HCBookShelf.h
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-16.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>

#define k_PULL_STATE_NORMAL         0     //  状态标识：下拉可以刷新/上拖加载更多
#define k_PULL_STATE_DOWN           1     //  状态标识：释放可以刷新
#define k_PULL_STATE_LOAD           2     //  状态标识：正在加载
#define k_PULL_STATE_UP             3     //  状态标识：释放加载更多
#define k_PULL_STATE_END            4     //  状态标识：已加载全部数据

#define k_RETURN_DO_NOTHING         0     //  返回值：不执行
#define k_RETURN_REFRESH            1     //  返回值：下拉刷新
#define k_RETURN_LOADMORE           2     //  返回值：加载更多

#define k_VIEW_TYPE_HEADER          0     //  视图标识：下拉刷新视图
#define k_VIEW_TYPE_FOOTER          1     //  视图标识：上拖加载视图

#define k_STATE_VIEW_HEIGHT         40    //  视图窗体：视图高度
#define k_STATE_VIEW_INDICATE_WIDTH 60    //  视图窗体：视图箭头指示器宽度

enum{
    StateViewType,
};
@interface StateView : UIView {
@private
}

@property (nonatomic, retain) UIActivityIndicatorView * indicatorView;
@property (nonatomic, retain) UIImageView             * arrowView;
@property (nonatomic, retain) UILabel                 * stateLabel;
@property (nonatomic, retain) UILabel                 * timeLabel;
@property (nonatomic)         int                       viewType;
@property (nonatomic)         int                       currentState;

/**
 *  初始化视图
 *  type : 下拉/上拖视图标识  k_VIEW_TYPE_HEADER 或 k_VIEW_TYPE_FOOTER
 **/
- (id)initWithFrame:(CGRect)frame viewType:(int)type;

/**
 *  改变视图状态
 *  state : 视图状态 k_PULL_STATE_XXX
 **/
- (void)changeState:(int)state;

/**
 *  更新时间文本（当前时间）
 **/
- (void)updateTimeLabel;

@end

#import "BookInfo.h"
#import "BookView.h"

#define BookViewTag 500
#define ButtonTag 1000
#define PriceBgTag 2000
#define PriceLabelTag 3000
#define ActivityTag 4000


@class HCBookShelf;

@protocol HCBookShelfDataSource <NSObject>
@optional
-(int)numberOfItemsForShell:(HCBookShelf *)bookShelf;
//-(BookInfo *)bookShlef:(HCBookShelf *)bookShelf imageForItemAtIndex:(NSInteger)index;
//-(int)bookShell:(HCBookShelf *)bookShelf priceForItemAtIndex:(NSInteger)index;
-(BookView *)bookViewForIndex:(NSInteger)index;
@end

@protocol HCBookShelfDelegate <NSObject>
@optional
-(void)bookShellk:(HCBookShelf *)bookShelf itemSelectedAtIndex:(NSInteger)index;
-(void)bookshelf:(HCBookShelf *)bookShelf deleteAtIndex:(NSInteger)index;
-(void)refreshUpdate;
-(void)loadMoreUpdate;
@end

@interface HCBookShelf : UIScrollView<UIScrollViewDelegate,BookViewDelegate>
@property (nonatomic,retain) StateView *headerView;
@property (nonatomic,retain) StateView *footerView;

@property (nonatomic,assign) int itemCount;
@property (nonatomic,assign) IBOutlet id <HCBookShelfDataSource> dataSource;
@property (nonatomic,assign) IBOutlet id <HCBookShelfDelegate> itemSelectedDelegate;
@property (nonatomic,assign) BOOL showPrice;

@property (nonatomic,retain) NSMutableArray *imagesStack;
-(void)reloadData;
-(void)updateData;
-(id)initWithFrame:(CGRect)frame;
@end
