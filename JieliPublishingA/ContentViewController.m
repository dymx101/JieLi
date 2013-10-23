//
//  ContentViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "ContentViewController.h"
#import "EPubViewController.h"
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]


@interface ContentViewController (){
    HCDownLoadingView *downingView;
    HCDownLoad *hcd;
}

@end

@implementation ContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:[NSString stringWithFormat:@"bookInfoFile%d",self.bookInfo.bookId]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.bookInfo];
    [data writeToFile:filename atomically:YES];
//    [NSKeyedArchiver archiveRootObject:self.bookInfo toFile:filename];

    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[self.bookInfo.bookName,self.bookInfo.bookThumb,[url absoluteString],filename] forKeys:@[@"bookName",@"bookThumb",@"fileUrl",@"bookInfoFile"]];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:[kDocument_Folder stringByAppendingPathComponent:@"epubBooksList.plist"]];
    if (!array) {
        array = [NSMutableArray array];
    }
    
    BOOL isNew = YES;
    for (NSDictionary *d in array) {
        if ([[d objectForKey:@"bookInfoFile"] isEqualToString:[dic objectForKey:@"bookInfoFile"]]) {
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
    epubController.bookInfo = self.bookInfo;
//    NSURL *urlA = [NSURL fileURLWithPath:path];
    //    NSURL *urlB = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"人生百忌2" ofType:@"epub"]];
    [epubController loadEpub:url];
//    [epubController release];
    epubController = nil;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self.contentBgImageView setImage:[PicNameMc imageFromImageName:F_image_woodFrame]];
    [self.contentBgImageView setImage:[UIImage imageNamed:@"F_image_woodFrame@2x.png"]];

}
-(void)loadBookInfo:(BookInfo *)info{
    if (!info.bookBrief||[info.bookBrief length]==0) {
        info.bookBrief = @"此书无简介";
    }

    [self.contentTextView setText:info.bookBrief];
    self.bookInfo = [info retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContentBgImageView:nil];
    [self setContentTextView:nil];
    [super viewDidUnload];
}
@end
