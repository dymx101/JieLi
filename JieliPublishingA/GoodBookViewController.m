//
//  GoodBookViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-12.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

enum {
    topBarButtonTag1,
    topBarButtonTag2,
    topBarButtonTag3,
    topBarButtonTag4,
};

#import "GoodBookViewController.h"
#import "HCBookShelf.h"
#import "DiyTopBar.h"
#import "PicNameMc.h"
#import "BookInfo.h"

#import "CategoriesView.h"

#import "HCTadBarController.h"
#import "ContentViewController.h"
#import "ShareViewController.h"
#import "CommentViewController.h"
#import "BuyViewController.h"

#import "EMagazineViewController.h"
@interface GoodBookViewController ()
@property (strong,nonatomic) NSMutableArray *items;


@property (strong, nonatomic) IBOutlet DiyTopBar *myTopBar;
@end

@implementation GoodBookViewController


-(AppDelegate *)app{
    if (!_app) {
        _app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return _app;
}
-(DataBrain *)dataBrain{
    if (!_dataBrain) {
        _dataBrain = self.app.dataBrain;
    }
    return _dataBrain;
}

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
//    self.items = [NSArray arrayWithObjects:@"新书上架", @"精品图书", @"畅销书榜", @"图书分类", nil];
//    [self.horizMenu reloadData];
    
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];
    
    self.topBarButton1.tag = topBarButtonTag1;
    self.topBarButton2.tag = topBarButtonTag2;
    self.topBarButton3.tag = topBarButtonTag3;
    self.topBarButton4.tag = topBarButtonTag4;
    
    [self.myTopBar setType:DiyTopBarTypeBack];
    [self.myTopBar.backButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    self.myTopBar.myTitle.text = @"接力书坊";
    [self.bgImageView setImage:[PicNameMc imageFromImageName:F_image_pattren1]];
    
    self.dataBrain.getListDelegate = self;
    [self.myBookShelf reloadData];
    [self barButtonPressed:self.topBarButton1];



}

-(void)getBookList:(NSString *)urlString withButtonTag:(int)index{
    NSLog(@"get list start");
}

-(void) viewDidAppear:(BOOL)animated
{
//    [self.bgImageView setImage:[PicNameMc imageFromImageName:F_image_pattren1]];
    [self.bgImageView setFrame:CGRectMake(0, 44, 320, 39)];

}
-(void)viewDidDisappear:(BOOL)animated{
}

- (IBAction)popBack:(id)sender {
    if (self.isCategoriesViewOpen) {
        self.categoriesView.hidden = NO;
        self.myBookShelf.hidden = YES;
        self.isCategoriesViewOpen = NO;
    }
    else{
    [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (IBAction)barButtonPressed:(UIButton*)sender {
    int index = sender.tag;
    UIImage *image = nil;
    self.myBookShelf.hidden = NO;
    self.categoriesView.hidden = YES;
    [self.myBookShelf.headerView changeState:k_PULL_STATE_NORMAL];
    [self.myBookShelf setContentOffset:CGPointMake(0, 0) animated:NO];

    switch (index) {
        case topBarButtonTag1:{
            self.bookShelfType = BookShelfType1;
            image = [PicNameMc imageFromImageName:F_image_pattren1];
            if ([self.dataBrain.newBookArray count]==0) {
                [self.dataBrain getMoreNewBookList];
            }
            else{
                self.bookShelfImageList = self.dataBrain.newBookArray;
                [self.myBookShelf reloadData];
            }
        }
            break;
        case topBarButtonTag2:{
            self.bookShelfType = BookShelfType2;
            image = [PicNameMc imageFromImageName:F_image_pattren2];
            if ([self.dataBrain.marketableArray count]==0) {
                [self.dataBrain getMarketableBookList];
            }
            else{
                self.bookShelfImageList = self.dataBrain.marketableArray;
                [self.myBookShelf reloadData];
            }
        }
            break;
        case topBarButtonTag3:{
            self.bookShelfType = BookShelfType3;
            image = [PicNameMc imageFromImageName:F_image_pattren3];
            if ([self.dataBrain.competitiveArray count]==0) {
                [self.dataBrain getCompetitiveBookList];
            }
            else{
                self.bookShelfImageList = self.dataBrain.competitiveArray;
                [self.myBookShelf reloadData];
            }
    }
            break;
        case topBarButtonTag4:{
            self.bookShelfType = BookShelfType4;
            image = [PicNameMc imageFromImageName:F_image_pattren4];
//            [self.dataBrain getBookCategories];
            
            if (!self.categoriesView) {
                self.categoriesView  = [[CategoriesView alloc] initWithFrame:CGRectMake(0, 74, 320, 339)];
                self.categoriesView.goodBook = self;
                [self.view addSubview:self.categoriesView];
            }
            else{
                self.categoriesView.hidden = NO;
            }
            self.myBookShelf.hidden = YES;
            
        }
            break;
        default:
            break;
    }
    [self.bgImageView setImage:image];
    
}
#pragma mark -
#pragma mark DataBrain delegate
-(void)finishGetListWithArray:(NSArray *)bookList withType:(int)type{
    self.bookShelfImageList = bookList;
    [self.myBookShelf reloadData];
    [self.myBookShelf.headerView changeState:k_PULL_STATE_NORMAL];
    [self.myBookShelf.footerView changeState:k_PULL_STATE_NORMAL];
    if ([bookList count] ==6) {
        [self.myBookShelf setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    [self performSelector:@selector(regainBookShelfcontentInset) withObject:nil afterDelay:.5f];
}
-(void)regainBookShelfcontentInset{
    self.myBookShelf.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)refreshUpdate{
    switch (self.bookShelfType) {
        case BookShelfType1:{
            self.dataBrain.newBookArray = nil;
            [self.dataBrain getMoreNewBookList];}
            break;
        case BookShelfType2:{
            self.dataBrain.marketableArray = nil;
            [self.dataBrain getMarketableBookList];}
            break;
        case BookShelfType3:{
            self.dataBrain.competitiveArray = nil;
            [self.dataBrain getCompetitiveBookList];}
            break;
        case BookShelfType4:{
            self.dataBrain.categorieListArray = nil;
            [self.dataBrain getCategorieList:self.categoriesView.currentButtonTag];
        }
            break;
            
        default:
            break;
    }
}
-(void)loadMoreUpdate{
    switch (self.bookShelfType) {
        case BookShelfType1:{
            [self.dataBrain getMoreNewBookList];}
            break;
        case BookShelfType2:{
            [self.dataBrain getMarketableBookList];}
            break;
        case BookShelfType3:{
            [self.dataBrain getCompetitiveBookList];}
            break;
        case BookShelfType4:{
            NSLog(@"%d",self.categoriesView.currentButtonTag);
            [self.dataBrain getCategorieList:self.categoriesView.currentButtonTag];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark -
#pragma mark HCBookShelf DataSource
-(int)numberOfItemsForShell:(HCBookShelf *)bookShelf{
    if (self.bookShelfImageList) {
        return [self.bookShelfImageList count]+3;
    }
    else {
        return 6+3;
    }
    
}
//-(BookInfo *)bookShlef:(HCBookShelf *)bookShelf imageForItemAtIndex:(NSInteger)index{
//    if (self.bookShelfImageList&&index>3) {
//        return [self.bookShelfImageList objectAtIndex:index];
//    }
//    else{
//        return nil;
//    }
//}
//-(int)bookShell:(HCBookShelf *)bookShelf priceForItemAtIndex:(NSInteger)index{
//    return index;
//}
-(BookView *)bookViewForIndex:(NSInteger)index{
    if (index<3) {
        BookView *bv = [[BookView alloc] initWithFrame:CGRectMake(0, 0, ImageViewWith, ImageViewHight+LabelHight) withCoverImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d-1.jpg",index+1]] withLableName:[NSString stringWithFormat:@"杂志测试%d",index+1]];
        
        return bv;
    }
    BookInfo *info = [self.bookShelfImageList objectAtIndex:index-3];
    BookView *bookView = [BookView BookViewWithBookInfo:info];
    return bookView;
}

#pragma mark -
#pragma mark HCBookShelf delegate
-(void)bookShellk:(HCBookShelf *)bookShelf itemSelectedAtIndex:(NSInteger)index{
    NSLog(@"buttonTouchedAt: %d",index);
    if (index<3) {
        EMagazineViewController *emvc = [[EMagazineViewController alloc] initWithNibName:@"EMagazineViewController" bundle:nil];
        emvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:emvc animated:YES];
        [emvc addEMagazineWithIndex:index+1];

        return;
    }
    BookInfo *info = [self.bookShelfImageList objectAtIndex:index-3];
    NSLog(@"%@",info);
    
    HCTadBarController *tabBarController = [[HCTadBarController alloc] init];
    tabBarController.bookInfo = info;
    
    
    tabBarController.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:tabBarController animated:YES];
    
    /*

     BookViewController *viewController = [[BookViewController alloc] initWithNibName:@"BookViewController" bundle:nil];
    
//    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    
    if (index<[self.bookShelfImageList count]) {
        BookInfo *info = [self.bookShelfImageList objectAtIndex:index];
        viewController.bookInfo = info;
        [viewController.myBookNameLabel setText:[viewController.myBookNameLabel.text stringByAppendingString:info.bookName]];
        [viewController.myAutherNameLabel setText:[viewController.myAutherNameLabel.text stringByAppendingString:info.bookAuthor]];
        [viewController.myPublishTimeLabel setText:[viewController.myPublishTimeLabel.text stringByAppendingString:info.bookDate]];
        [viewController.myBookPriceLabel setText:[viewController.myBookPriceLabel.text stringByAppendingString:[NSString stringWithFormat:@"%0.2f",info.bookPrice]]];
        if ([info.bookBrief length]==0) {
            info.bookBrief = @"此书无简介";
        }
//        NSLog(@"askfdjlasjfkd:%@",info.bookBrief);
        [viewController.myTextView setText:info.bookBrief];
        
        [viewController.myCoverImageview setImage:[UIImage imageWithData:[DataBrain readFilewithImageId:info.bookId withFlolderName:BookCoverImage]]];
    }
    else{
        return;
    }
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setTopBarButton1:nil];
    [self setTopBarButton2:nil];
    [self setTopBarButton3:nil];
    [self setTopBarButton4:nil];
    [self setBgImageView:nil];
    [self setMyTopBar:nil];
    [self setMyBookShelf:nil];
    [self setBackGroundImageView:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [_backGroundImageView release];
    [super dealloc];
}
@end
