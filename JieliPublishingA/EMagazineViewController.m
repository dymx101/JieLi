//
//  EMagazineViewController.m
//  JieliPublishingA
//
//  Created by HuaChen on 13-5-28.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "EMagazineViewController.h"
#import "PicNameMc.h"
@interface EMagazineViewController ()

@end

@implementation EMagazineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    UIImageView *topBarBg = [[UIImageView alloc] initWithFrame:self.topBar.frame];
    UIImage *image = [PicNameMc defaultBackgroundImage:@"Readfunctionbox" withWidth:320 withTitle:nil withColor:nil];
    [topBarBg setImage:image];
    [self.topBar addSubview:topBarBg];
    [self.topBar sendSubviewToBack:topBarBg];
    
    NSArray *array = [PicNameMc imageName:@"Readfunction@2x.png" numberOfH:1 numberOfW:4];
    [self.popBackButton setImage:[array objectAtIndex:0] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [self.scrollView addGestureRecognizer:tap];
    self.scrollView.tag = 100;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    int page = scrollView.contentOffset.x /scrollView.bounds.size.width;
    if (scrollView.tag == 100) {
        return nil;
    }
    int page = scrollView.tag;
    return [self.pageArray objectAtIndex:page];

}// return a view that will be scaled. if delegate returns nil, nothing happens
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view NS_AVAILABLE_IOS(3_2){

}// called before the scroll view begins zooming its content
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    if (scrollView.tag != 100) {
        int page = scrollView.tag;
        UIImageView *imageView = [self.pageArray objectAtIndex:page];
        [scrollView setContentSize:CGSizeMake(imageView.frame.origin.x*2 +imageView.frame.size.width, imageView.frame.origin.y*2 +imageView.frame.size.height)];
    }

    
}// scale between minimum and maximum. called after any 'bounce' animations

-(void)taped:(UITapGestureRecognizer *)tap{
    self.topBar.hidden = !self.topBar.hidden;
}
-(void)addEMagazineWithIndex:(int)index{
    int num = 0;
    switch (index) {
        case 1:
            num = 5;
            break;
        case 2:
            num = 5;
            break;
        case 3:
            num = 5;
            break;
            
        default:
            break;
    }
    float width = self.scrollView.frame.size.width;
    float height = self.scrollView.frame.size.height;

    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i<=num; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d-%d.jpg",index,i]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        imageView.center = CGPointMake(width/2 + width*(i-1), height/2);
        UIScrollView *sview = [[UIScrollView alloc] initWithFrame:CGRectMake(width*(i-1), 0, width, height)];
        imageView.center = CGPointMake(width/2, height/2);
        [sview addSubview:imageView];
        sview.minimumZoomScale = 0.3;
        sview.maximumZoomScale = 2;
        sview.showsHorizontalScrollIndicator = NO;
        sview.showsVerticalScrollIndicator = NO;
        sview.delegate = self;
        sview.tag = i-1;
        [self.scrollView addSubview:sview];
        [array addObject:imageView];
    }
    self.pageArray  = [[NSArray alloc] initWithArray:array];
    [self.scrollView setContentSize:CGSizeMake(width*num, height)];


}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag == 100) {
        int page = scrollView.contentOffset.x /scrollView.bounds.size.width;
        //通过滚动的偏移量来判断目前页面所对应的小白点
        [self.pageNumber setText:[NSString stringWithFormat:@"%d/%d",page+1,5]];

    }
    
}// any offset changes

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollView release];
    [_pageNumber release];
    [_topBar release];
    [_popBackButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageNumber:nil];
    [self setTopBar:nil];
    [self setPopBackButton:nil];
    [super viewDidUnload];
}
@end
