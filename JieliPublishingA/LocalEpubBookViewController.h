//
//  LocalEpubBookViewController.h
//  JieLiShelf
//
//  Created by HuaChen on 13-5-28.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiyTopBar.h"
#import "HCBookShelf.h"
@interface LocalEpubBookViewController : UIViewController<BookViewDelegate>
@property (retain, nonatomic) IBOutlet DiyTopBar *topBar;
@property (retain, nonatomic) IBOutlet HCBookShelf *bookShelf;
@property (retain,nonatomic) NSMutableArray *ebooks;
@property (retain, nonatomic) IBOutlet UIImageView *backGroundImageView;
@end
