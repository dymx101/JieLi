//
//  HCTadBarController.m
//  testTabView
//
//  Created by 花 晨 on 13-3-5.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "HCTadBarController.h"
#import "CMTabBarUtils.h"
#pragma mark--
#pragma mark HCTabBar
@interface HCTabBar ()
@property (nonatomic,strong) UIImageView *backGroundImageView;
@property (nonatomic,strong) UIImageView *selectedImageView;

@property (nonatomic, retain) NSArray*      buttons;
- (UIImage*)defaultBackgroundImage ;

@end
@implementation HCTabBar

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgImage = [self defaultBackgroundImage];
        self.backGroundImageView = [[UIImageView alloc] initWithImage:bgImage];
        self.backGroundImageView.center = CGPointMake(self.center.x,self.frame.size.height/2 );
        [self addSubview:self.backGroundImageView];
        
        
        NSArray *imageNames = [NSArray arrayWithObjects:@"forButton1",@"forButton2",@"forButton3",@"forButton4", nil];
        [self setItems:imageNames];
        
        self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
        self.selectedImageView.center = CGPointMake(40, -1);
        [self addSubview:self.selectedImageView];

    }
    return self;
}
#pragma mark - Public


- (void)setItems:(NSArray*)imageNames {
    // Add KVO for each UITabBarItem
    
    
    NSMutableArray* newButtons = [NSMutableArray array];
    
    
    CGSize buttonSize = CGSizeMake(self.frame.size.width / [imageNames count], 31);
    
    for (int i=0; i < [imageNames count]; i++) {
        UIImage *image = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(i * buttonSize.width,4, buttonSize.width, buttonSize.height)];
        
        UIImage* buttonImage = [CMTabBarUtils tabBarImage:image size:buttonSize backgroundImage:[self getGrayImage]];
        UIImage* selectImage = [CMTabBarUtils tabBarImage:image size:buttonSize backgroundImage:nil];

        [button setImage:buttonImage forState:UIControlStateNormal];
        [button setImage:buttonImage forState:UIControlStateDisabled];
        [button setImage:selectImage forState:UIControlStateHighlighted];
        [button setImage:selectImage forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i == self.selectedIndex) {
            [button setImage:[button imageForState:UIControlStateSelected] forState:UIControlStateNormal];
        }
        
        [newButtons addObject:button];
    }
    
    self.buttons = nil;
    self.buttons = [[NSArray alloc] initWithArray:newButtons];
}
-(void)buttonPressed:(UIButton *)button{
    
    [self.delegate tabBar:self selectAtIndex:button.tag];
    [self reSetSelectedImageViewCenterWithButtonTag:button.tag animated:YES];
}
-(void)reSetSelectedImageViewCenterWithButtonTag:(int)index animated:(BOOL)animated{
    for (UIButton *btn in self.buttons) {
        if (btn.tag!=index) {
            [btn setImage:[btn imageForState:UIControlStateDisabled] forState:UIControlStateNormal];
        }
        else {
            [btn setImage:[btn imageForState:UIControlStateSelected] forState:UIControlStateNormal];
        }
    }

    CGPoint  centerPoint = CGPointMake(40+index*80, -1);
    if (!animated) {
        self.selectedImageView.center = centerPoint;
    }
    else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.selectedImageView.center = centerPoint;
        [UIView commitAnimations];
    }
    
}
-(UIImage *)getGrayImage{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(80, 31), NO, 0.0);
    float n = 165.0/255;
    [[UIColor colorWithRed:n green:n blue:n alpha:1] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0,0, 80,31));
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}


#pragma mark - Private

- (UIImage*)defaultBackgroundImage {
    CGFloat width = 320;
    // Get the image that will form the top of the background
    UIImage* topImage = [UIImage imageNamed:@"gBar"];
    
    // Create a new image context
    //UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, topImage.size.height*2 + 5), NO, 0.0);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, self.frame.size.height), NO, 0.0);
    
    // Create a stretchable image for the top of the background and draw it
    UIImage* stretchedTopImage = [topImage stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    //[stretchedTopImage drawInRect:CGRectMake(0, 5, width, topImage.size.height)];
    [stretchedTopImage drawInRect:CGRectMake(0, 0, width, topImage.size.height)];
    
    // Draw a solid black color for the bottom of the background
//    if (self.useGlossEffect) {
//        [[UIColor blackColor] set];
//        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, self.frame.size.height / 2, width, self.frame.size.height / 2));
//    }
    
    // Generate a new image
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}



- (UIImage*)defaultSelectionIndicatorImage {
    return [UIImage imageNamed:@"glow.png"];
}

@end

#pragma mark--
#pragma mark HCTadBarController

#import "DiyTopBar.h"
#import "BasicBookViewController.h"
#import "BackGroundImageView.h"

static NSArray *actionBtnTexts;
@interface HCTadBarController (){
    BOOL isJudgePage;
}
@property (nonatomic,strong) UIScrollView *rootScrollView;
@property (nonatomic,strong) DiyTopBar *topBar;
@property (nonatomic,strong) BookDetailViewController *bookDetailController;
//@property (nonatomic,strong) 
@end

@implementation HCTadBarController


-(NSArray *)viewControllers{
    if (!_viewControllers) {
        ContentViewController *vc1 = [[ContentViewController alloc] initWithNibName:@"ContentViewController" bundle:nil];
        vc1.tabBarController = self;
        ShareViewController *vc2 = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
        vc2.bookId = [NSString stringWithFormat:@"%d",self.bookInfo.bookId];

        CommentViewController *vc3 = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil];
        vc3.delegate = self;
        BuyViewController *vc4 = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
        vc4.tabBarController = self;
        
        _viewControllers = [[NSArray alloc] initWithObjects:vc1, vc2, vc3, vc4, nil];
    }
    return _viewControllers;
}

-(DiyTopBar *)topBar{
    if (!_topBar) {
        _topBar = [[DiyTopBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self.view addSubview:_topBar];
        _topBar.myTitle.text = @"书籍详情";
        [_topBar setType:DiyTopBarTypeBackAndCollect];
        [_topBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        [_topBar.collectButton addTarget:self action:@selector(collectBook) forControlEvents:UIControlEventTouchUpInside];
        [self reloadTopBarState];

    }
    return _topBar;
}
-(BookDetailViewController *)bookDetailController{
    if (!_bookDetailController) {
        _bookDetailController = [[BookDetailViewController alloc] initWithNibName:@"BookDetailViewController" bundle:nil];
        _bookDetailController.view.frame = CGRectMake(0, 44, _bookDetailController.view.frame.size.width, _bookDetailController.view.frame.size.height);
        _bookDetailController.delegate = self;
        [self.view addSubview:_bookDetailController.view];
    }
    return _bookDetailController;
}

-(UIScrollView *)rootScrollView{
    if (!_rootScrollView) {
        CGRect winRect = [[UIScreen mainScreen] bounds];
        CGSize winSize = winRect.size;
        _rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBar.bounds.size.height+self.bookDetailController.view.frame.size.height, winSize.width, winSize.height - self.tabBar.bounds.size.height-self.topBar.bounds.size.height -self.bookDetailController.view.frame.size.height-20)];
        _rootScrollView.delegate = self;
        [_rootScrollView setPagingEnabled:YES];
        _rootScrollView.showsHorizontalScrollIndicator = NO;
        _rootScrollView.bounces = NO;
        [self.view addSubview:_rootScrollView];
    }
    return _rootScrollView;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    NSString *text = [actionBtnTexts objectAtIndex:selectedIndex];
    UIButton *b = self.bookDetailController.actionButton;
    b.tag = selectedIndex;
//    if (selectedIndex == 3) {
//        b.hidden = YES;
//    }
//    else{
//        b.hidden = NO;
    [b setImage:[PicNameMc buttonBg:b title:text] forState:UIControlStateNormal];
//    }
    NSLog(@"index:%d",selectedIndex);

}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isJudgePage = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = self.rootScrollView.contentOffset.x /self.rootScrollView.bounds.size.width +0.5;
    //通过滚动的偏移量来判断目前页面所对应的小白点
//    self.MyPageControl.currentPage = page;//pagecontroll响应值的变化
    if (page!=self.selectedIndex&&isJudgePage) {
        self.selectedIndex = page;
        [self.tabBar reSetSelectedImageViewCenterWithButtonTag:page animated:YES];
        
    }
}// any offset changes
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int page = self.rootScrollView.contentOffset.x /self.rootScrollView.bounds.size.width +0.5;
    //通过滚动的偏移量来判断目前页面所对应的小白点
    //    self.MyPageControl.currentPage = page;//pagecontroll响应值的变化
    if (page!=self.selectedIndex) {
        self.selectedIndex = page;
        [self.tabBar reSetSelectedImageViewCenterWithButtonTag:page animated:YES];
        
    }

}// called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating


-(void)loadViewController:(BookInfo *)info{
    for (int i = 0; i<[self.viewControllers count]; i++) {
        BasicBookViewController *viewController = [self.viewControllers objectAtIndex:i];
        [self.rootScrollView addSubview:viewController.view];
        viewController.view.frame = CGRectMake(self.view.frame.size.width*i, 0, self.rootScrollView.bounds.size.width, self.rootScrollView.bounds.size.height);
        [viewController loadBookInfo:info];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    isJudgePage = YES;
    if (!actionBtnTexts) {
        actionBtnTexts = [[NSArray alloc] initWithObjects:@"在线阅读",@"发送分享",@"我要评价",@"购买", nil];
    }
    [self.view addSubview:[[BackGroundImageView alloc] initWithFrame:self.view.frame]];
    
    self.tabBar = [[HCTabBar alloc] initWithFrame:CGRectMake(0,self.view.frame.size.height - 35, 320, 35)];
    self.tabBar.delegate = self;
    [self.view addSubview:self.tabBar];
    
    
    
    CGRect winRect = [[UIScreen mainScreen] bounds];
    CGSize winSize = winRect.size;
    [self.rootScrollView setContentSize:CGSizeMake(winSize.width*[self.viewControllers count], 0)];
    [self loadViewController:self.bookInfo];
    
    [self.view bringSubviewToFront:self.tabBar];

    [self.bookDetailController loadBookInfo:self.bookInfo];
    [self.view bringSubviewToFront:self.bookDetailController.view];
    
}
-(void)tabBar:(HCTabBar *)tabBar selectAtIndex:(NSUInteger)index{
    isJudgePage= NO;
    [self.rootScrollView setContentOffset:CGPointMake(self.rootScrollView.frame.size.width*index, 0) animated:YES];
}

-(void)popBack{
    [[AppDelegate shareQueue] cancelAllOperations];
    for (id view in self.view.subviews) {
        if ([view isKindOfClass:[UIWebView class]]) {
            [view removeFromSuperview];
            return;
        }
    }

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reloadTopBarState{
    if ([AppDelegate idCollectedBook:self.bookInfo]) {
        [_topBar.collectButton setTitle:@"取消" forState:UIControlStateNormal];
    }
    else{
        [_topBar.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    }
    
}
-(void)collectBook{
    [AppDelegate collectABook:self.bookInfo];
    [self reloadTopBarState];
    NSLog(@"%d",[AppDelegate getCollectedBooks].count);
    
    NSString *title;
    if ([AppDelegate idCollectedBook:self.bookInfo]) {
        title = @"成功收藏此图书";
    }
    else{
        title = @"已取消收藏此图书";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

-(void)actionPressed:(UIButton *)b{
    NSLog(@"%d",b.tag);
    UIViewController *vc =[self.viewControllers objectAtIndex:b.tag];
    switch (b.tag) {
        case 0:
            [(ContentViewController *)vc readOnLine];
            break;
        case 1:
            [(ShareViewController *)vc sendWeiBo];
            
            break;
        case 2:
            [(CommentViewController *)vc iWantComment];
            break;
        case 3:
            [(BuyViewController *)vc buy];

        default:
            break;
    }
    
}

//--------------
-(void)pushTo:(LogViewController *)v{
    [self.navigationController pushViewController:v animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
