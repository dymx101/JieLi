//
//  BookView.m
//  JieliPublishingA
//
//  Created by 花 晨 on 13-1-29.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "BookView.h"
#import "DataBrain.h"
#import "NetImageView.h"

@interface BookView ()
//{
//    id taget_;
//    SEL action_;
//}
//@property (assign,nonatomic) id taget_;
//@property (assign,nonatomic) SEL action_;
@end

@implementation BookView

+(id)BookViewWithBookInfo:(BookInfo*)bookInfo withPosition:(CGPoint)position{
    
    
    return [[self alloc] initWithFrame:CGRectMake(position.x-ImageViewWith/2, position.y-ImageViewWith/2, ImageViewWith, ImageViewHight+LabelHight) withBookId:bookInfo];
}
+(id)BookViewWithBookInfo:(BookInfo*)bookInfo{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, ImageViewWith, ImageViewHight+LabelHight) withBookId:bookInfo];
}

//-(void)addTaget:(id)taget action:(SEL)action{
//    self.taget_ = taget;
//    self.action_ = action;
//}
-(void)bookViewBeTapped{
//    id tager = self.taget_;
//    SEL action = self.action_;
//    [tager performSelector:action withObject:self];
    if (self.isLoadImageFinish) {
        [self.delegate bookViewBeTouched:self];
    }
}
-(UIButton *)delButton{
    if (!_delButton) {
        _delButton = [[UIButton alloc] initWithFrame:CGRectMake(-10, -7, 30, 30)];
//        [_delButton setBackgroundColor:[UIColor blackColor]];
        [_delButton setImage:[UIImage imageNamed:@"SinaWeibo.bundle/images/close"] forState:UIControlStateNormal];
        [self addSubview:_delButton];
        [_delButton addTarget:self action:@selector(deleteSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delButton;
}
-(void)deleteSelf{
    if ([self.delegate respondsToSelector:@selector(bookViewBeDelete:)]) {
        [self.delegate bookViewBeDelete:self];

    }
}
-(void)editModelStart{
    self.delButton.hidden = NO;
}
-(void)editModelEnd{
    self.delButton.hidden = YES;
}
-(id)initWithFrame:(CGRect)frame withCoverImageUrl:(NSString *)coverImageUrl withLableName:(NSString *)lableName{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.isLoadImageFinish = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookViewBeTapped)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageViewWith, ImageViewHight)];
        [view setImage:[UIImage imageNamed:@"defaultImage.png"]];
        [self addSubview:view];
        self.imageView = view;
        view = nil;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ImageViewHight, ImageViewWith, LabelHight)];
        [self addSubview:label];
        [label setBackgroundColor:[UIColor clearColor]];
        label.numberOfLines = 2;
        [label setFont:[UIFont fontWithName:@"ArialMT" size:12]];
        
        if (lableName) {
            label.text = lableName;
        }
        else{
            label.text = @"";
        }
        self.labelView = label;
        label = nil;
        
        UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.imageView.center.x-AIViewWith/2, self.imageView.center.y-AIViewHight/2, AIViewWith, AIViewHight)];
        [self addSubview:actView];
        [actView startAnimating];
        self.activityIndicatorView = actView;
        actView = nil;
        
        NSString *imageUrl = coverImageUrl;
        
        NetImageView *imageView = [NetImageView NetImageViewWithUrl:imageUrl withTarget:self];
        imageView.frame = self.imageView.frame;
        [self addSubview:imageView];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame withCoverImage:(UIImage *)coverImage withLableName:(NSString*)lableName{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.isLoadImageFinish = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookViewBeTapped)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];

        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageViewWith, ImageViewHight)];
        [view setImage:coverImage];
        [self addSubview:view];
        self.imageView = view;
        view = nil;
        self.isLoadImageFinish = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ImageViewHight, ImageViewWith, LabelHight)];
        [self addSubview:label];
        [label setBackgroundColor:[UIColor clearColor]];
        label.numberOfLines = 2;
        [label setFont:[UIFont fontWithName:@"ArialMT" size:12]];
        [label setText:lableName];


    }
    return self;
}
-(id)initWithFrame:(CGRect)frame withBookId:(BookInfo*)bookInfo_{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.isLoadImageFinish = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookViewBeTapped)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        self.bookInfo = bookInfo_;
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageViewWith, ImageViewHight)];
        [view setImage:[UIImage imageNamed:@"defaultImage.png"]];
        [self addSubview:view];
        self.imageView = view;
        view = nil;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ImageViewHight, ImageViewWith, LabelHight)];
        [self addSubview:label];
        [label setBackgroundColor:[UIColor clearColor]];
        label.numberOfLines = 2;
        [label setFont:[UIFont fontWithName:@"ArialMT" size:12]];

        if (bookInfo_.bookName) {
           label.text = bookInfo_.bookName;
        }
        else{
            label.text = @"";
        }
        self.labelView = label;
        label = nil;
        
        UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.imageView.center.x-AIViewWith/2, self.imageView.center.y-AIViewHight/2, AIViewWith, AIViewHight)];
        [self addSubview:actView];
        [actView startAnimating];
        self.activityIndicatorView = actView;
        actView = nil;
        
        NSString *imageUrl = bookInfo_.bookThumb;

        NetImageView *imageView = [NetImageView NetImageViewWithUrl:imageUrl withTarget:self];
        imageView.frame = self.imageView.frame;
        [self addSubview:imageView];
        
        
}
    return self;
}

-(void)NetImageViewFinish:(NetImageView *)netImageView{
    self.isLoadImageFinish = YES;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:1.75];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.imageView cache:YES];
    [self.imageView setImage:netImageView.image];
//    [UIView commitAnimations];

    [self.activityIndicatorView stopAnimating];
}

-(void)loadImageViewWithImage:(UIImage *)image{
    if (!image) {
        return;
    }
    self.isLoadImageFinish = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.imageView cache:YES];
    [self.imageView setImage:image];
    [UIView commitAnimations];
    
    [self.activityIndicatorView stopAnimating];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
