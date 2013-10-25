//
//  BuyViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "BuyViewController.h"
#import "AppDelegate.h"
#import "BuyBookCell.h"
#import "CBuyOperation.h"
#import "PicNameMc.h"
#import "InAppJieLiIAPHelper.h"
#import "EPubViewController.h"
#import "GetProductsList.h"
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface BuyViewController (){
    NSMutableArray *arrayOfCells;
    CBuyOperation *op;
    HCDownLoadingView *downingView;
    HCDownLoad *hcd;
}
@end

@implementation BuyViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidUnload{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    if (!op.isFinished) {
        [op cancel];
        
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
}
//-(void)viewDidAppear:(BOOL)animated{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:) name:kProductPurchasedNotification object:nil];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(purchased:) name:kProductPurchasedNotification object:nil];
    
    // Do any additional setup after loading the view from its nib.
    arrayOfCells = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)buy{
    NSString *identifier = [NSString stringWithFormat:@"com.%06d",self.bookInfo.bookId];
    [GetProductsList getProductsList:^(BOOL success, id result) {
        NSSet *sset = (NSSet *)result;
        BOOL isHave = NO;
        for (NSString *sss in sset) {
            if ([identifier isEqualToString:sss]) {
                [[[InAppJieLiIAPHelper alloc] initWithProductIdentifiers:[NSSet setWithObject:identifier]] requestProducts];
                isHave = YES;
            }
        }
        if (!isHave) {
            NSLog(@"不提供下载");
            UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:@"本书暂不提供下载" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
            [al show];

        }
    }];
    
    
//    InAppJieLiIAPHelper *inapp = [InAppJieLiIAPHelper sharedHelper];
//    [inapp requestProducts];
}
-(void)productsLoaded:(NSNotification *)notification{
    NSObject *obj = [notification object];
    if ([obj isKindOfClass:[NSArray class]]) {
        NSArray *products = (NSArray *)obj;
        [[InAppJieLiIAPHelper sharedHelper] buyProductIdentifier:products[0]];
    }
}
-(void)purchased:(NSNotification *)notification{
    [self readOnLine];
}
-(void)readOnLine{
    
    //    NSString *epubUrlString  = self.bookInfo.epub_all;
    downingView = [HCDownLoadingView DownLoadingView];
    downingView.delegate =self;
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    [window addSubview:downingView];
    
    // 大鼻子    http://www.jielibj.com/download.php?path=images/201305/1368083752379138435.epub
    // 工作就这样炼成了   http://www.jielibj.com/download.php?path=images/201305/1368083672567368490.epub
    //人生百忌 http://www.jielibj.com/download.php?path=images/201305/1368082963753484197.epub
    
//    NSString *epubName = self.bookInfo.epub_all;
    NSString *epubName = @"http://www.jielibj.com/download.php?path=images/201305/1368082963753484197.epub";
    hcd = [HCDownLoad downLoadWithURL:[NSURL URLWithString:epubName]];
    hcd.delegate = self;
    [hcd start];
    
}
-(void)HCDownLoadingViewClose:(HCDownLoadingView *)view{
    [hcd cancel];
    [view removeFromSuperview];
    view = nil;
}
-(void)HCdownloadDoing:(HCDownLoad *)downLoad progress:(float)progress{
    NSLog(@"p:%f",progress);
    [downingView.proGressView setProgress:progress];
}
//-(void)HCdownloadFinish:(HCDownLoad *)downLoad withData:(NSData *)data{
//    [downingView.proGressView setProgress:1];
//    [downingView removeFromSuperview];
//
//
//        EPubViewController *epubController = [[EPubViewController alloc] initWithNibName:@"EPubView" bundle:nil];
//        [self.tabBarController.navigationController pushViewController:epubController animated:YES];
//
//    NSURL *urlA = [NSURL fileURLWithPath:path];
////    NSURL *urlB = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"人生百忌2" ofType:@"epub"]];
//        [epubController loadEpub:urlA];
//}
-(void)HCdownloadFinish:(HCDownLoad *)downLoad withFileUrl:(NSURL *)url{
    [downingView.proGressView setProgress:1];
    [downingView removeFromSuperview];
    
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.bookInfo.bookName,self.bookInfo.bookThumb,[url absoluteString]] forKeys:@[@"bookName",@"bookThumb",@"fileUrl"]];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[kDocument_Folder stringByAppendingPathComponent:@"epubBooksList.plist"]];
    if (!array) {
        array = [NSMutableArray array];
    }
    
    BOOL isNew = YES;
    for (NSDictionary *d in array) {
        if ([[d objectForKey:@"fileUrl"] isEqualToString:[dic objectForKey:@"fileUrl"]]) {
            isNew = NO;
        }
    }
    if (isNew) {
        [array addObject:dic];
        [array writeToFile:[kDocument_Folder stringByAppendingPathComponent:@"epubBooksList.plist"] atomically:YES];
    }
    
    
    //    [[NSUserDefaults standardUserDefaults] setObject:[array retain] forKey:@"epubBooks"];
    
    EPubViewController *epubController = [[EPubViewController alloc] initWithNibName:@"EPubView" bundle:nil];
    [self.tabBarController.navigationController pushViewController:epubController animated:YES];
    
    //    NSURL *urlA = [NSURL fileURLWithPath:path];
    //    NSURL *urlB = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"人生百忌2" ofType:@"epub"]];
    [epubController loadEpub:url];
    
}
-(void)loadBookInfo:(BookInfo *)info{
    self.bookInfo = info;
//    [self.dataBrain getCrawlList:self.bookInfo.bookId];
    op = [[CBuyOperation alloc] initWithTaget:self withBookId:self.bookInfo.bookId];
    [[AppDelegate shareQueue] addOperation: op];
//    [[AppDelegate shareQueue] ]


}
#pragma mark
#pragma mark -- 

-(void)loadData:(id)result{
    NSLog(@"%@",result);
    if ([result isKindOfClass:[NSDictionary class]]) {
        return;
    }

    self.arrayOfBuyBoooks = [[NSArray alloc] initWithArray:result];
    [self.tableView reloadData];

}






#pragma mark
#pragma mark -- BuyBookView tebleView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arrayOfBuyBoooks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%d",indexPath.row);
    NSDictionary *dic = [self.arrayOfBuyBoooks objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:[dic objectForKey:@"href"]];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 480-44)];
    [self.view.superview.superview addSubview:webView];
    NSLog(@"%@",webView);
//    [self.view.superview bringSubviewToFront:webView];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    [webView loadRequest:req];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BuyBookCell" owner:self options:nil];
    BuyBookCell *cell = [nib objectAtIndex:0];
    
    
    UIImage *image;
    NSDictionary *dic = [self.arrayOfBuyBoooks objectAtIndex:indexPath.row];
    NSString *price = [dic objectForKey:@"price_now"];
    price = [@"¥" stringByAppendingString:price];
    cell.priceLabel.text = price;
    
    NSString *tz = [dic objectForKey:@"source_web"];
    
    if ([tz isEqualToString:@"amazon.com"]) {
        image = [[PicNameMc imageName:@"buyBookCellImages@2x.png" numberOfH:3 numberOfW:1] objectAtIndex:1];
    }
    else if ([tz isEqualToString:@"360buy.com"]) {
        image = [[PicNameMc imageName:@"buyBookCellImages@2x.png" numberOfH:3 numberOfW:1] objectAtIndex:2];
        
        if (![dic objectForKey:@"price_now"]) {
        
        
        cell.priceLabel.hidden = YES;
        NSURL *url = [NSURL URLWithString:[dic objectForKey:@"price_now_url"]];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if ([data length]>0 &&error == nil) {
                
                UIImage *urlImage = [UIImage imageWithData:data];
                NSArray *array = [[NSArray alloc] initWithObjects:cell,urlImage, nil];
                
                
                [self performSelectorOnMainThread:@selector(loadImage:) withObject:array waitUntilDone:NO];
                
            }
            else if ([data length] == 0 && error == nil){
                NSLog(@"Nothing was downloaded.");
            }
            else if (error != nil){
                NSLog(@"Error happened = %@", error);
            }
        }];
        }
    }
//    else if ([tz isEqualToString:@"dangdang.com"]) {
    else{
        image = [[PicNameMc imageName:@"buyBookCellImages@2x.png" numberOfH:3 numberOfW:1] objectAtIndex:0];
    }
    
    [cell.logoImageView setImage:image];
    
    return cell;
    
}
-(void)loadImage:(NSArray *)array{
    BuyBookCell *cell = [array objectAtIndex:0];
    UIImage *image = [array objectAtIndex:1];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(cell.priceLabel.frame.origin.x, cell.priceLabel.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
    [cell addSubview:imageView];
}



@end
