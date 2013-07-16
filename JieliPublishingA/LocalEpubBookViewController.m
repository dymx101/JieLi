//
//  LocalEpubBookViewController.m
//  JieLiShelf
//
//  Created by HuaChen on 13-5-28.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "LocalEpubBookViewController.h"
#import "EPubViewController.h"
#import "PicNameMc.h"
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface LocalEpubBookViewController ()

@end

@implementation LocalEpubBookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"书架", @"书架");
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_4"];

    }
    return self;
}
-(void)edit{
    if ([self.topBar.collectButton.titleLabel.text isEqualToString:@"编辑"]) {
        [self.topBar.collectButton setTitle:@"完成" forState:UIControlStateNormal];
        for (BookView *view in self.bookShelf.subviews) {
            if ([view isKindOfClass:[BookView class]]) {
                [view editModelStart];
            }
        }
    }
    else{
        [self.topBar.collectButton setTitle:@"编辑" forState:UIControlStateNormal];
        for (BookView *view in self.bookShelf.subviews) {
            if ([view isKindOfClass:[BookView class]]) {
                [view editModelEnd];
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];

    [self.topBar setType:DiyTopBarTypeCollect];
    [self.topBar.collectButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.topBar.backButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar.collectButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
    self.topBar.myTitle.text = @"本地图书";
    self.bookShelf.headerView.hidden = YES;
    self.bookShelf.footerView.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self.topBar updateThemeColor];
    [self.backGroundImageView setImage:[PicNameMc backGroundImage]];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.ebooks = [NSMutableArray arrayWithContentsOfFile:[kDocument_Folder stringByAppendingPathComponent:@"epubBooksList.plist"]];
    NSLog(@"%@",self.ebooks);
    [self.bookShelf reloadData];
    
}

#pragma mark -
#pragma mark HCBookShelf DataSource
-(int)numberOfItemsForShell:(HCBookShelf *)bookShelf{
    if (self.ebooks) {
       return[self.ebooks count];
    }
    return 0;
}
//@"bookName",@"bookThumb",@"fileUrl"
-(BookView *)bookViewForIndex:(NSInteger)index{
    NSDictionary *dic = [self.ebooks objectAtIndex:index];
    NSString *filename = [dic objectForKey:@"bookInfoFile"];
    
    BookInfo *bookInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];

//    BookView *bv = [[BookView alloc] initWithFrame:CGRectMake(0, 0, ImageViewWith, ImageViewHight+LabelHight) withCoverImageUrl:bookInfo.bookThumb withLableName:bookInfo.bookName];
    BookView *bv = [BookView BookViewWithBookInfo:bookInfo];
    return bv;
}


#pragma mark -
#pragma mark HCBookShelf delegate
-(void)bookShellk:(HCBookShelf *)bookShelf itemSelectedAtIndex:(NSInteger)index{
    NSLog(@"buttonTouchedAt: %d",index);
    EPubViewController *epubController = [[EPubViewController alloc] initWithNibName:@"EPubView" bundle:nil];
    [self.navigationController pushViewController:epubController animated:YES];
    NSDictionary *dic = [self.ebooks objectAtIndex:index];

    NSString *urlString = [dic objectForKey:@"fileUrl"];
    NSString *filename = [dic objectForKey:@"bookInfoFile"];
    
    BookInfo *bookInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    epubController.bookInfo = bookInfo;
    NSURL *url = [NSURL URLWithString:urlString];
    [epubController loadEpub:url];
}
-(void)bookshelf:(HCBookShelf *)bookShelf deleteAtIndex:(NSInteger)index{
    [self.ebooks removeObjectAtIndex:index];
    [self.ebooks writeToFile:[kDocument_Folder stringByAppendingPathComponent:@"epubBooksList.plist"] atomically:YES];
    [self.bookShelf reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_topBar release];
    [_bookShelf release];
    [_backGroundImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopBar:nil];
    [self setBookShelf:nil];
    [self setBackGroundImageView:nil];
    [super viewDidUnload];
}
@end
