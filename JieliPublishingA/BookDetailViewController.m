//
//  BookDetailViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-3-6.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "BookDetailViewController.h"
#import "DataBrain.h"
#import "PicNameMc.h"
#import "NetImageView.h"
@interface BookDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *coverImage;
@property (strong, nonatomic) IBOutlet UILabel *bookName;
@property (strong, nonatomic) IBOutlet UILabel *authorName;
@property (strong, nonatomic) IBOutlet UILabel *publisher;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end

@implementation BookDetailViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.actionButton setImage:[PicNameMc buttonBg:self.actionButton title:@"在线阅读"] forState:UIControlStateNormal];
    [self.actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *shdow = [[UIImageView alloc] initWithImage:[PicNameMc defaultBackgroundImage:@"bookDetailShow" withWidth:320 withTitle:nil withColor:nil]];
    shdow.frame = CGRectMake(0, self.view.bounds.size.height, shdow.frame.size.width, shdow.frame.size.height);
    [self.view addSubview:shdow];
}
-(void)buttonPressed:(UIButton *)b{
    [self.delegate actionPressed:b];
}
-(void)loadBookInfo:(BookInfo *)info{
    NSString *bookName = info.bookName;
    NSLog(@"%@:%@",bookName,info);
    self.bookInfo = info;
    
//    [self.coverImage setImage:[UIImage imageWithData:[DataBrain readFilewithImageId:info.bookId withFlolderName:BookCoverImage]]];
    NetImageView *niv = [NetImageView NetImageViewWithUrl:self.bookInfo.bookThumb];
    niv.frame = self.coverImage.frame;
    [self.coverImage.superview addSubview:niv];
    [self.coverImage removeFromSuperview];
    self.coverImage = nil;
    self.coverImage = niv;
    
    
    if (info.bookName) {
        [self.bookName setText:[self.bookName.text stringByAppendingString:info.bookName]];
    }
    if (info.bookAuthor) {
        [self.authorName setText:[self.authorName.text stringByAppendingString:info.bookAuthor]];
    }
    [self.publisher setText:[self.publisher.text stringByAppendingString:@"接力出版社"]];
    [self.price setText:[self.price.text stringByAppendingString:[NSString stringWithFormat:@"%0.2f",info.bookPrice]]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setCoverImage:nil];
    [self setBookName:nil];
    [self setAuthorName:nil];
    [self setPublisher:nil];
    [self setPrice:nil];
    [self setActionButton:nil];
    [super viewDidUnload];
}
@end
