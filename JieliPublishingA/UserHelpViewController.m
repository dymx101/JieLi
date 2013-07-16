//
//  UserHelpViewController.m
//  JieLiShelf
//
//  Created by HuaChen on 13-7-9.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "UserHelpViewController.h"

@interface UserHelpViewController ()

@end

@implementation UserHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)popBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.topBar.myTitle.text = @"使用帮助";
    [self.topBar setType:DiyTopBarTypeBack];
    [self.topBar.backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    

    self.helpImageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"userHelp_1.png"],[UIImage imageNamed:@"userHelp_2.png"],[UIImage imageNamed:@"userHelp_3.png"], nil];

    for (int i = 0; i<[_helpImageArray count]; i++) {
        UIImage *image = [self.helpImageArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(320*i , 0, image.size.width/2, image.size.height/2);
        [self.scrollView addSubview:imageView];
    }
    [self.scrollView setContentSize:CGSizeMake(320*[_helpImageArray count], 0)];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setPagingEnabled:YES];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = self.scrollView.contentOffset.x /self.scrollView.bounds.size.width;
    //通过滚动的偏移量来判断目前页面所对应的小白点
    self.pageControl.currentPage = page;//pagecontroll响应值的变化
}// any offset changes
- (IBAction)changepage:(id)sender {
    int page = self.pageControl.currentPage;//获取当前pagecontroll的值
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_pageControl release];
    [_topBar release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setTopBar:nil];
    [super viewDidUnload];
}
@end
