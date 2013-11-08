//
//  SecondViewController.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-10-12.
//  Copyright (c) 2012年 中卡. All rights reserved.
//
#import "SecondViewController.h"
#import "PicNameMc.h"
#import "HotWordLabel.h"


#define H_CONTROL_ORIGIN CGPointMake(20, 70)

@interface SecondViewController ()
@property (nonatomic,strong) BookShelfTableViewController *tC;
@property (nonatomic,strong) UIWebView *webView;
@end


@implementation SecondViewController
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
        NSLog(@"%@: %@", NSStringFromSelector(_cmd), self);
        self.title = NSLocalizedString(@"搜索", @"搜索");
        self.tabBarItem.image = [UIImage imageNamed:@"tabBar_2"];
    }
    return self;
}
- (IBAction)viewTap:(id)sender {
    [self returnKeyBoard];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.myDiyTopBar updateThemeColor];
    [self.myBgImageView setImage:[PicNameMc backGroundImage]];
    [self.tC.view setBackgroundColor:[UIColor colorWithPatternImage:[PicNameMc backGroundImage]]];
    if (self.tC) {
        [self.tC.view setHidden:YES];
    }
}

+(UIColor *)getRGBfromSixteen:(NSString *)color{
    int R = 0;
    char R1 = [color characterAtIndex:0];
    char R2 = [color characterAtIndex:1];
    R= ((R1>64)?R1-55:R1-48)*16 + ((R2>64)?R2-55:R2-48);
    
    int G = 0;
    char G1 = [color characterAtIndex:2];
    char G2 = [color characterAtIndex:3];
    G= ((G1>64)?G1-55:G1-48)*16 + ((G2>64)?G2-55:G2-48);

    int B = 0;
    char B1 = [color characterAtIndex:4];
    char B2 = [color characterAtIndex:5];
    B= ((B1>64)?B1-55:B1-48)*16 + ((B2>64)?B2-55:B2-48);

    DMLog(@"%d,%d,%d",R,G,B);
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
}
-(NSArray *)getHotWords{
    NSArray *keys = @[@"word",@"center",@"fountSize",@"color",@"link"];
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *obs1 = @[@"I SPY 视觉大发现",@"100120",@"17",@"CC0033",@"http://www.jielibj.com/article.php?id=380"];
    NSArray *obs2 = @[@"抓坏蛋",@"60180",@"15",@"00CC66",@"http://www.jielibj.com/article.php?id=366"];
    NSArray *obs3 = @[@"管好自己就能飞",@"120300",@"16",@"663366",@"http://www.jielibj.com/article.php?id=375"];
    NSArray *obs4 = @[@"刘墉",@"160160",@"16",@"999999",@"http://www.jielibj.com/search.php?encode=YTozOntzOjg6ImtleXdvcmRzIjtzOjY6IuWImOWiiSI7czoxMDoiaW1hZ2VGaWVsZCI7czo2OiLmkJzntKIiO3M6MTg6InNlYXJjaF9lbmNvZGVfdGltZSI7aToxMzY5NjQ3OTQ2O30="];
    NSArray *obs5 = @[@"蓝精灵",@"250130",@"16",@"0000FF",@"http://www.jielibj.com/search.php?encode=YTozOntzOjg6ImtleXdvcmRzIjtzOjk6IuiTneeyvueBtSI7czoxMDoiaW1hZ2VGaWVsZCI7czo2OiLmkJzntKIiO3M6MTg6InNlYXJjaF9lbmNvZGVfdGltZSI7aToxMzY5NjQ4MDA2O30="];
    NSArray *obs6 = @[@"巴巴爸爸",@"250200",@"16",@"CCCC33",@"http://www.jielibj.com/search.php?encode=YTozOntzOjg6ImtleXdvcmRzIjtzOjEyOiLlt7Tlt7TniLjniLgiO3M6MTA6ImltYWdlRmllbGQiO3M6Njoi5pCc57SiIjtzOjE4OiJzZWFyY2hfZW5jb2RlX3RpbWUiO2k6MTM2OTY0ODEwMDt9"];
    NSArray *obs7 = @[@"曹文轩",@"100360",@"16",@"000000",@"http://www.jielibj.com/search.php?encode=YTozOntzOjg6ImtleXdvcmRzIjtzOjk6IuabueaWh%2bi9qSI7czoxMDoiaW1hZ2VGaWVsZCI7czo2OiLmkJzntKIiO3M6MTg6InNlYXJjaF9lbmNvZGVfdGltZSI7aToxMzY5NjQ4MjY4O30="];
    NSArray *obs8 = @[@"秦文君",@"260280",@"16",@"9966CC",@"http://www.jielibj.com/search.php?encode=YTozOntzOjg6ImtleXdvcmRzIjtzOjk6IuenpuaWh%2bWQmyI7czoxMDoiaW1hZ2VGaWVsZCI7czo2OiLmkJzntKIiO3M6MTg6InNlYXJjaF9lbmNvZGVfdGltZSI7aToxMzY5NjQ4Mjg2O30="];
    NSArray *obs9 = @[@"第一次发现",@"160240",@"16",@"CC3399",@"http://www.jielibj.com/category.php?id=17"];

    NSArray *arrayobs = @[obs1,obs2,obs3,obs4,obs5,obs6,obs7,obs8,obs9];
    for (NSArray *ar in arrayobs) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:ar forKeys:keys];
        [array addObject:dic];
    }
    
    return array;
}
-(void)loadHotWords{
    NSArray *keys = @[@"word",@"center",@"fountSize",@"color",@"link"];
    NSArray *array = [self getHotWords];
    for (NSDictionary *dic in array) {
        NSArray *objs = [dic objectsForKeys:keys notFoundMarker:[NSNull null]];
        NSString *name = [objs objectAtIndex:0];
        CGPoint center = CGPointMake([[objs objectAtIndex:1] intValue]/1000, [[objs objectAtIndex:1] intValue]%1000);
        float fountSize = [[objs objectAtIndex:2] floatValue];
        
        CGSize labelSize = [name sizeWithFont:[UIFont boldSystemFontOfSize:fountSize]];
        
        
        UIColor *color = [[self class]getRGBfromSixteen:[objs objectAtIndex:3]];
        
        HotWordLabel *label = [[HotWordLabel alloc] initWithFrame:CGRectMake(0, 0, labelSize.width, labelSize.height)];
        
//        [label setBackgroundColor:[UIColor clearColor]];
        [label setText:name];
        [label setTextColor:color];
        [label setFont:[UIFont fontWithName:@"Arial" size:fountSize]];
        label.center = center;
        label.linkUrl = [objs objectAtIndex:4];
        label.keyWord = [objs objectAtIndex:0];
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelLinkTo:)];
        [label addGestureRecognizer:tap];
        
        [self.view addSubview:label];
        [label release];
        label= nil;
        
        DMLog(@"%@",objs);
    }
}
-(void)labelLinkTo:(UITapGestureRecognizer *)tap{
    
    UIActivityIndicatorView *aiv;
    aiv = (UIActivityIndicatorView *)[self.myDiyTopBar viewWithTag:10010];
    if (aiv) {
        [aiv startAnimating];
    }
    else{
        aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(320-40, 0, 40, 40)];
        [self.myDiyTopBar addSubview:aiv];
        aiv.tag = 10010;
        [aiv startAnimating];
    }

    
    HotWordLabel *label = (HotWordLabel *)tap.view;
    
    NSString *keyWord = label.keyWord;
    self.myTextField.text = label.keyWord;
    SearchPoeration *op = [[SearchPoeration alloc] initWithKeyWord:keyWord];
    op.delegate = self;
    [[AppDelegate shareQueue] addOperation:op];

//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.myBgImageView.frame];
//    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:label.linkUrl]];
//    [webView loadRequest:req];
//    [self.view addSubview:webView];
//    
//    self.webView = webView;
//    [webView release];
//    webView = nil;
//
//    [self.myDiyTopBar setType:DiyTopBarTypeBack];
//    [self.myDiyTopBar.backButton addTarget:self action:@selector(cancelWebView) forControlEvents:UIControlEventTouchUpInside];
//    self.myDiyTopBar.backButton.hidden = NO;
    
}

-(void)cancelWebView{
    if (self.webView) {
        [self.webView removeFromSuperview];
        [self.webView release];
        self.webView = nil;
        self.myDiyTopBar.backButton.hidden = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.myBgImageView setImage:[PicNameMc backGroundImage]];
    [self.myDiyTopBar.myTitle setText:@"图书搜索"];
    [self.sBackground setImage:[PicNameMc defaultBackgroundImage:@"sBg" withWidth:self.sBackground.frame.size.width withTitle:nil withColor:nil]];
    [self.myTextField setBackground:[PicNameMc defaultBackgroundImage:@"inputBox@2x.png" size:self.myTextField.frame.size leftCapWidth:10 topCapHeight:10]];
    self.dataBrain.getListDelegate = self;
    
    NSString *initParam = [[NSString alloc] initWithFormat:
						   @"server_url=%@,appid=%@",ENGINE_URL,APPID];
    
	// init the RecognizeControl
    // 初始化语音识别控件
	_iFlyRecognizeControl = [[IFlyRecognizeControl alloc] initWithOrigin:H_CONTROL_ORIGIN initParam:initParam];
	
    [self.view addSubview:_iFlyRecognizeControl];
    
    // Configure the RecognizeControl
    // 设置语音识别控件的参数,具体参数可参看开发文档
	[_iFlyRecognizeControl setEngine:@"sms" engineParam:nil grammarID:nil];
	[_iFlyRecognizeControl setSampleRate:16000];
	_iFlyRecognizeControl.delegate = self;
    
    
    [self loadHotWords];
    
}

- (IBAction)searchButtonPressed:(id)sender {
    [self search];
}



-(NSString *)deleteKongke:(NSString *)string{
    
    NSMutableString *Mstring = [[NSMutableString alloc] initWithString:string];
    NSRange rang = [Mstring rangeOfString:@" "];
    if (rang.length) {
        [Mstring deleteCharactersInRange:rang];
        return [self deleteKongke:Mstring];
    }
    else{
        return Mstring;
    }
}
- (void)search {
    UIActivityIndicatorView *aiv;
    aiv = (UIActivityIndicatorView *)[self.myDiyTopBar viewWithTag:10010];
    if (aiv) {
        [aiv startAnimating];
    }
    else{
    aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(320-40, 0, 40, 40)];
    [self.myDiyTopBar addSubview:aiv];
    aiv.tag = 10010;
    [aiv startAnimating];
    }
    NSString *searchString = [self deleteKongke:self.myTextField.text];
    int number = searchString.length;

    if (number) {
        NSLog(@"以关键字：%@搜索",searchString);
        [self returnKeyBoard];
        NSString *keyWord = searchString;
        SearchPoeration *op = [[SearchPoeration alloc] initWithKeyWord:keyWord];
        op.delegate = self;
        [[AppDelegate shareQueue] addOperation:op];
    }
}

-(void)finishPoeration:(id)result{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self.myDiyTopBar viewWithTag:10010];
    [aiv stopAnimating];
    [aiv removeFromSuperview];
    aiv = nil;

    if (!result) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"图书搜索" message:@"没有搜索到相关内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [av show];

        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 367)];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://book.douban.com/subject_search?search_text=%@&cat=1001",self.myTextField.text]];
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://book.douban.com/subject_search?search_text=%@&cat=1001",[self.myTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//        NSURL *url = [NSURL URLWithString:@"http://book.douban.com/subject_search?search_text=%E5%A4%A7%E4%BA%BA&cat=1001"];
        [webView loadRequest:[[NSURLRequest alloc] initWithURL:url]];
        webView.tag = 30010;
        [self.view addSubview:webView];
        
        [self.myDiyTopBar setType:DiyTopBarTypeBack];
        [self.myDiyTopBar.backButton addTarget:self action:@selector(removeWebView) forControlEvents:UIControlEventTouchUpInside];
        return;
    }
    NSLog(@"%@",result);
    NSArray *array = [BookInfo bookInfoWithJSON:result];
    if (self.tC) {
        [self.tC.tableView removeFromSuperview];
        self.tC = nil;
    }
    
        self.tC = [[BookShelfTableViewController alloc] initWithStyle:UITableViewStylePlain];
        self.tC.delegate = self;
        [self.tC.tableView setBackgroundColor:[UIColor clearColor]];
        [self.tC.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tC.tableView setShowsVerticalScrollIndicator:NO]; 
        [self.tC loadBooks:array];
        [self.tC.tableView setFrame:CGRectMake(0, 85, 320,326)];
    [self.tC.view setBackgroundColor:[UIColor colorWithPatternImage:[PicNameMc backGroundImage]]];
    
        [self.view addSubview:self.tC.tableView];
}

-(void)removeWebView{
    UIWebView *webView = (UIWebView *)[self.view viewWithTag:30010];
    [webView removeFromSuperview];
    webView = nil;
    
    [self.myDiyTopBar setType:DiyTopBarTypeNone];
}
-(void)pushOut:(HCTadBarController *)tab{
    [self.navigationController pushViewController:tab animated:YES];
}

#pragma mark
#pragma TextFiledrDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self returnKeyBoard];
    [self search];
    return YES;
}





-(void)returnKeyBoard{
    [self.myTextField endEditing:YES];
}
-(void)disableButton{
    [self returnKeyBoard];
}
- (IBAction)onButtonRecognize:(id)sender {
    if([_iFlyRecognizeControl start])
	{
        [self.view bringSubviewToFront:_iFlyRecognizeControl];
		[self disableButton];
	}

}

-(void)onUpdateTextField:(NSString *)sentence{
    if ([sentence length]>0) {
        NSMutableString *string = [NSMutableString stringWithString:sentence];
        [string replaceCharactersInRange:NSMakeRange([sentence length]-1, 1) withString:@" "];
        sentence = string;

    }
    NSString *str = [[NSString alloc] initWithFormat:@"%@%@", self.myTextField.text, sentence];
	self.myTextField.text = str;
	NSLog(@"str");
    [str release];
    str=nil;

}

- (void)onRecognizeResult:(NSArray *)array
{
    //  execute the onUpdateTextView function in main thread
    //  在主线程中执行onUpdateTextView方法
	[self performSelectorOnMainThread:@selector(onUpdateTextField:) withObject:
	 [[array objectAtIndex:0] objectForKey:@"NAME"] waitUntilDone:YES];
}




#pragma mark
#pragma 语音接口实现

- (void) onGrammer:(NSString *)grammer error:(int)err
{
    NSLog(@"the error is:%d",err);
    
}

- (void) onRecognizeEnd:(IFlyRecognizeControl *)iFlyRecognizeControl theError:(int)error
{
    NSLog(@"识别结束回调finish.....");
	NSLog(@"getUpflow:%d,getDownflow:%d",[iFlyRecognizeControl getUpflow],[iFlyRecognizeControl getDownflow]);
    
}

- (void)onResult:(IFlyRecognizeControl *)iFlyRecognizeControl theResult:(NSArray *)resultArray
{
	[self onRecognizeResult:resultArray];
	
}


//=================================================

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setMyTextField:nil];
    [self setMyBgImageView:nil];
    [self setMyDiyTopBar:nil];
    [self setSBackground:nil];
    [self setSeachButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [_seachButton release];
    [super dealloc];
}
@end
