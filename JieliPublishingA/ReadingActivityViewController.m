//
//  ReadingActivityViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-24.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "ReadingActivityViewController.h"
#import "DetailInfoOfActivityViewController.h"
#import "PicNameMc.h"
#import <QuartzCore/QuartzCore.h>
#import "DataBrain.h"
enum{
    bgImageOnTag,
    bgImageOffTag
};
@implementation ReadingCard
-(void)awakeFromNib{
    [self.myBgImageView setImage:[PicNameMc imageFromImageName:F_image_poste]];
    [self.ThumbImageView.layer setMasksToBounds:YES];
    [self.ThumbImageView.layer setCornerRadius:10.0f];
    
    [self.joinButton setBackgroundImage:[PicNameMc imageFromImageName:F_btn_joinActivity] forState:UIControlStateNormal];
    [self.shareButton setBackgroundImage:[PicNameMc imageFromImageName:F_btn_shareActivity] forState:UIControlStateNormal];

}
-(void)loadData:(id)r{
    
    GetImageOperation *op = [[GetImageOperation alloc] initWithImageId:[[r objectForKey:@"id"] integerValue] url:[r objectForKey:@"image_lmobile"] withFloderName:ActivityCardImage];
    op.delegate = self;
    [[AppDelegate shareQueue] addOperation:op];
    [self.titleLabel setText:[r objectForKey:@"title"]];
    
    [self.timeLabel setText:[self.timeLabel.text stringByAppendingFormat:@"%@--%@",[r objectForKey:@"begin_time"],[r objectForKey:@"end_time"]]];
    [self.addressLabel setText:[self.addressLabel.text stringByAppendingString:[r objectForKey:@"address"]]];
    self.activityId = [[r objectForKey:@"id"] integerValue];
    
    
}
-(void)finishGetImage:(UIImage *)image{
    CGSize siz = image.size;
    float height = self.ThumbImageView.frame.size.height;
    float width = self.ThumbImageView.frame.size.width;
            CGRect rect = CGRectMake((siz.width-width)/2, (siz.height-height)/2, width, height);
            CGImageRef imageRef=CGImageCreateWithImageInRect([image CGImage],rect);
            UIImage* elementImage=[UIImage imageWithCGImage:imageRef];
            

    [self.ThumbImageView setImage:elementImage];
}

@end


@interface ReadingActivityViewController ()

@end

@implementation ReadingActivityViewController

-(DataBrain *)dataBrain{
    if (!_dataBrain) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _dataBrain = app.dataBrain;
    }
    return _dataBrain;
}
-(NSMutableDictionary *)actIdandMainId{
    if (!_actIdandMainId) {
        _actIdandMainId = [[NSMutableDictionary alloc] init];
    }
    return _actIdandMainId;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)pushToDetail:(UITapGestureRecognizer *)tap{
    ReadingCard *readingCardView = (ReadingCard *)[tap view] ;
    NSLog(@".......%d",readingCardView.activityId);
    DetailInfoOfActivityViewController *viewController = [[DetailInfoOfActivityViewController alloc] initWithNibName:@"DetailInfoOfActivityViewController" bundle:nil];
    viewController.activityId = readingCardView.activityId;
    viewController.mainId = readingCardView.mainId;
    [self.navigationController pushViewController:viewController animated:YES];

}


- (void)viewDidLoad 
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.myRootImageView setImage:[PicNameMc backGroundImage]];
    self.myTopBar.myTitle.text = @"读书活动";

    if (self.shareEventUrl) {
        self.myTopBar.myTitle.text = @"分享的活动";
    }
    
    if (self.pushEventUrl) {
        self.myTopBar.myTitle.text = @"推送的活动";
    }
    
    
    [self.myTopBar setType:DiyTopBarTypeBack];
    [self.myTopBar.backButton addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
    self.button_onLine.tag = bgImageOnTag;
    self.button_offLine.tag = bgImageOffTag;
    
    [self.myScrollView setPagingEnabled:YES];
    [self.myScrollView setShowsHorizontalScrollIndicator:NO];
    self.myScrollView.delegate = self;


//    [self.dataBrain getActivityList];
//    self.dataBrain.getListDelegate = self;
    
    [self.actI startAnimating];
    
//    PosX = 0;
    NSOperationQueue *q = (NSOperationQueue *)[AppDelegate shareQueue];
    NSLog(@"queue Numbers %d",[q.operations count]);
    
    NSString *url =@"?c=Activity&m=getDBActivityList";
    if (self.shareEventUrl) {
        url = self.shareEventUrl;
    }
    if (self.pushEventUrl){
        url = self.pushEventUrl;
    }
    
    BasicOperation *bOp = [[BasicOperation alloc] initWithUrl:url];
    bOp.tag = 0;
    bOp.delegate = self;
    [[AppDelegate shareQueue] addOperation:bOp];
    
//    int events[5] = {18357834,17758278,17755502,18401705,18228563};
//    for (int i = 0; i<5; i++) {
//        ReadEventOperation *op = [[ReadEventOperation alloc] initWithEventId:events[i]];
//        op.delegate = self;
//        [[AppDelegate shareQueue] addOperation:op];
//    }
//    
//    self.myPageControl.numberOfPages = 5;

//    ReadEventOperation *op = [[ReadEventOperation alloc] initWithEventId:events[0]];
//    op.delegate = self;
//    [[AppDelegate shareQueue] addOperation:op];
//    
//    NSString *urlString = [@"https://api.douban.com/v2/event/" stringByAppendingString:[NSString stringWithFormat:@"%d",18234559]];
//    NSURL *url = [NSURL URLWithString:@"https://api.douban.com/v2/event/18234559"];
//
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    NSLog(@"123:%@",data);
}
-(void)finishOperationWithOperation:(id)op result:(id)result{
    if ([op isKindOfClass:[BasicOperation class]]) {
        BasicOperation *bop = (BasicOperation *)op;
        if (bop.tag == 0) {
            NSLog(@"%@",result);
            if (self.shareEventUrl) {
                [self.actI stopAnimating];
                if (!result) {
                    UIAlertView *alv = [[UIAlertView alloc] initWithTitle:@"分享的活动" message:@"您没有分享任何活动" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    alv.tag = 4001;
                    [alv show];

                }
            }
            
            [self getEventInfomation:result];
            
            
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 4001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)getEventInfomation:(id)eInfo{
    for (NSDictionary *dic in eInfo) {
        int eventId = [[dic objectForKey:@"db_id"] intValue];
        [self.actIdandMainId setObject:[dic objectForKey:@"id"] forKey:[dic objectForKey:@"db_id"]];
        ReadEventOperation *op = [[ReadEventOperation alloc] initWithEventId:eventId];
        op.delegate = self;
        [[AppDelegate shareQueue] addOperation:op];
        NSLog(@"%@",self.actIdandMainId);
    }
    self.myPageControl.numberOfPages = [eInfo count];

}
-(void)finishReadingPoeration:(id)result{
    NSLog(@"result:%@",result);
    
    [self loadDouBanEvent:result];
}

-(void)loadDouBanEvent:(id)r{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReadingCard" owner:self options:nil];
    ReadingCard *view = [nib objectAtIndex:0];
    [self.myScrollView addSubview:view];

    view.mainId = [[self.actIdandMainId objectForKey:[r objectForKey:@"id"]] intValue];
    [view loadData:r];
    
    view.frame = CGRectMake(PosX, 0, view.frame.size.width, view.frame.size.height);
    PosX +=view.frame.size.width;

    [self.myScrollView setContentSize:CGSizeMake(PosX, 0)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToDouBanDetail:)];
    [tap setNumberOfTapsRequired:1];
    tap.delegate = self;
    [view addGestureRecognizer:tap];


}
-(void)pushToDouBanDetail:(UITapGestureRecognizer *)tap{
    ReadingCard *readingCardView = (ReadingCard *)[tap view] ;
    NSLog(@".......%d",readingCardView.activityId);
    
    DetailInfoOfActivityViewController *viewController = [[DetailInfoOfActivityViewController alloc] initWithNibName:@"DetailInfoOfActivityViewController" bundle:nil];
    viewController.mainId = readingCardView.mainId;
    viewController.activityId = readingCardView.activityId;
    [self.navigationController pushViewController:viewController animated:YES];
    

}

-(void)setTextByKey:(NSString *)key withDic:(NSDictionary *)dic withLabel:(UILabel *)label isCover:(BOOL)isCover{
    NSString *text = [dic objectForKey:key];
    if (isCover) {
        label.text = text;
    }
    else{
        label.text = [label.text stringByAppendingString:text];
    }
}
-(void)loadReadingCard:(NSArray *)array{
    int pageNumber = MIN(10, [self.dataBrain.ActivityList count]);
    self.myPageControl.numberOfPages = pageNumber;
    
    float posX = 0;
    
    for (int i = 0; i<pageNumber; i++) {
        NSDictionary *dic = [self.dataBrain.ActivityList objectAtIndex:i];
        if (!dic) {
            continue;
        }
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReadingCard" owner:self options:nil];
        ReadingCard *view = [nib objectAtIndex:0];
        view.frame = CGRectMake(posX, 0, view.frame.size.width, view.frame.size.height);
        [self.myScrollView addSubview:view];
        
        [self setTextByKey:@"activityName" withDic:dic withLabel:view.titleLabel isCover:YES];
        [self setTextByKey:@"activityDate" withDic:dic withLabel:view.timeLabel isCover:NO];
        [self setTextByKey:@"activityAdress" withDic:dic withLabel:view.addressLabel isCover:NO];
        
        view.activityId = [[dic objectForKey:@"activityId"] integerValue];
        int viewId =-1; 
        viewId =[[dic objectForKey:@"activityId"] integerValue];
        if (viewId ==-1) {
            continue;
        }
        NSData *data = [DataBrain readFilewithImageId:viewId withFlolderName:ActivityImage];
        if (data) {
            NSLog(@"从本地读取图片,ID:%d",viewId);
            
            UIImage *image = [UIImage imageWithData:data ];
            [view.ThumbImageView setImage:image];
            //            image = nil;
            //            NSLog(@"%d readFile end",bookInfo.bookId);
            
        }
        else{
            NSURL *imageUrl = [NSURL URLWithString:[dic objectForKey:@"activityThumbBig"]];
            if (imageUrl == nil) {
                NSLog(@"图片缺失,ID:%d",viewId);
            }
            else{
                
                [self setImageWithId:viewId withImageUrl:(imageUrl) withObject:view];
            }
        }

        
        
        view.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToDetail:)];
        [tap setNumberOfTapsRequired:1];
        tap.delegate = self;
        [view addGestureRecognizer:tap];
        
        posX +=view.frame.size.width;
    }
    [self.myScrollView setContentSize:CGSizeMake(posX, 0)];
    [self.myScrollView setPagingEnabled:YES];
    [self.myScrollView setShowsHorizontalScrollIndicator:NO];
    self.myScrollView.delegate = self;

}

-(void)setImageWithId:(int)subViewId withImageUrl:(NSURL *)url withObject:(id)object{
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            
            [DataBrain writeFile:data withIndex:subViewId withFlolderName:ActivityImage];
            
            NSArray *array = [NSArray arrayWithObjects:data,object, nil];
            
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
-(void)loadImage:(NSArray *)array{
    NSData *data = [array objectAtIndex:0];
    ReadingCard *subView = [array objectAtIndex:1];
    
    UIImage *image = [UIImage imageWithData:data ];
    [subView.ThumbImageView setImage:image];
    image = nil;
    
}



#pragma dataBrainDelegate
-(void)finishGetListWithArray:(NSArray *)bookList withType:(int)type{
    NSLog(@"%@",bookList);
    [self loadReadingCard:bookList];
    [self.actI stopAnimating];
//    [self.actI removeFromSuperview];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = self.myScrollView.contentOffset.x /self.myScrollView.bounds.size.width;
    //通过滚动的偏移量来判断目前页面所对应的小白点
    self.myPageControl.currentPage = page;//pagecontroll响应值的变化
}// any offset changes

- (IBAction)changePage:(id)sender {
    int page = self.myPageControl.currentPage;//获取当前pagecontroll的值
    [self.myScrollView setContentOffset:CGPointMake(self.myScrollView.bounds.size.width * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}


//- (IBAction)barButtonPressed:(UIButton *)sender {
//    int index = sender.tag;
//    UIImage *image;
//    switch (index) {
//        case bgImageOnTag:
//            image = [PicNameMc imageFromImageName:F_image_on];
//            break;
//        case bgImageOffTag:
//            image = [PicNameMc imageFromImageName:F_image_off];
//            break;
//        default:
//            break;
//    }
//    [self.bgImageView setImage:image];
//    
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popBack:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)viewDidUnload {
    [self setMyTopBar:nil];
    [self setButton_onLine:nil];
    [self setButton_offLine:nil];
    [self setBgImageView:nil];
    [self setMyScrollView:nil];
    [self setMyPageControl:nil];
    [self setMyRootImageView:nil];
    [self setActI:nil];
//    NSOperationQueue *q =(NSOperationQueue *)[AppDelegate shareQueue];
//    for (NSOperation *p in q.operations) {
//        [p cancel];
//    }
//    [q.operations removeAllActions];
    
    [super viewDidUnload];
}
@end
