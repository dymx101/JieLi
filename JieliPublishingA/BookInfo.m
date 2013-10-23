//
//  BookInfo.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-11-21.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "BookInfo.h"
#define BookId @"bookId"
#define BookName @"bookName"
#define BookAuthor @"bookAuthor"
#define BookDate @"bookDate"
#define BookPrice @"bookPrice"
#define BookImage @"bookImage"
#define BookThumb @"bookThumb"
#define BookBrief @"bookBrief"
#define BookClickCount @"bookClickCount"
#define BookEpubAll @"bookEpubAll"
#define BookEpubUnAll @"bookEpubUnall"

@implementation BookInfo

+(NSArray *)bookInfoWithJSON:(id)dics{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dics) {
        BookInfo *bookInfo = [BookInfo bookInfoWithBookId:[[dic objectForKey:@"bookId"] intValue]
                                             withBookName:[dic objectForKey:@"bookName"]
                                           withBookAuthor:[dic objectForKey:@"bookAuthor"]
                                             withBookDate:[dic objectForKey:@"bookDate"]
                                            withBookPrice:[[dic objectForKey:@"bookPrice"] floatValue]
                                            withBookImage:[dic objectForKey:@"bookImage"]
                                            withBookThumb:[dic objectForKey:@"bookThumb"]
                                            withBookBrief:[dic objectForKey:@"bookBrief"]
                                       withBookClickCount:[[dic objectForKey:@"bookClickCount"] intValue]
                                          withBookEpubAll:[dic objectForKey:@"goods_bookimg_all"]
                                        withBookEpubUnall:[dic objectForKey:@"goods_bookimg_unall"]
                              ];
        [array addObject:bookInfo];
    }
    return array;
}

+(id)bookInfoWithBookId:(int )bookId
           withBookName:(NSString *)bookName
         withBookAuthor:(NSString *)bookAuthor
           withBookDate:(NSString *)bookDate
          withBookPrice:(float)bookPrice
          withBookImage:(NSString *)bookImage
          withBookThumb:(NSString *)bookThumb
          withBookBrief:(NSString *)bookBrief
     withBookClickCount:(int)bookClickCount            withBookEpubAll:(NSString *)epubAll
      withBookEpubUnall:(NSString *)epubUnall
{
    return [[self alloc] initBookInfoWithBookId:bookId withBookName:bookName withBookAuthor:bookAuthor withBookDate:bookDate withBookPrice:bookPrice withBookImage:bookImage withBookThumb:bookThumb withBookBrief:bookBrief withBookClickCount:bookClickCount withBookEpubAll:epubAll withBookEpubUnall:epubUnall];
    
}

-(id)initBookInfoWithBookId:(int )bookId
               withBookName:(NSString *)bookName
             withBookAuthor:(NSString *)bookAuthor
               withBookDate:(NSString *)bookDate
              withBookPrice:(float)bookPrice
              withBookImage:(NSString *)bookImage
              withBookThumb:(NSString *)bookThumb
              withBookBrief:(NSString *)bookBrief
         withBookClickCount:(int)bookClickCount
            withBookEpubAll:(NSString *)epubAll
          withBookEpubUnall:(NSString *)epubUnall
{
    if (self = [super init]) {
        if ((NSNull *)bookName == [NSNull null]) {
            bookName = nil;
        }
        if ((NSNull *)bookAuthor == [NSNull null]) {
            bookAuthor = nil;
        }
        if ((NSNull *)bookDate == [NSNull null]) {
            bookDate = nil;
        }
        if ((NSNull *)bookImage == [NSNull null]) {
            bookImage = nil;
        }
        if ((NSNull *)bookThumb == [NSNull null]) {
            bookThumb = nil;
        }
        if ((NSNull *)bookBrief == [NSNull null]) {
            bookBrief = nil;
        }
        if ((NSNull *)epubAll ==[NSNull null]) {
            epubAll = nil;
        }
        if ((NSNull *)epubUnall == [NSNull null]) {
            epubUnall = nil;
        }
        
        self.bookId = bookId;
        self.bookImage = bookImage;
        self.bookName = bookName;
        self.bookAuthor = bookAuthor;
        self.bookDate = bookDate;
        self.bookPrice = bookPrice;
        self.bookThumb = bookThumb;
        self.bookBrief = bookBrief;
        self.bookClickCount = bookClickCount;
        self.epub_all = epubAll;
        self.epub_unall = epubUnall;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInt:self.bookId] forKey:BookId];
    [aCoder encodeObject:self.bookName forKey:BookName];
    [aCoder encodeObject:self.bookAuthor forKey:BookAuthor];
    [aCoder encodeObject:self.bookDate forKey:BookDate];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.bookPrice] forKey:BookPrice];
    [aCoder encodeObject:self.bookImage forKey:BookImage];
    [aCoder encodeObject:self.bookThumb forKey:BookThumb];
    [aCoder encodeObject:self.bookBrief forKey:BookBrief];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.bookClickCount] forKey:BookClickCount];
    [aCoder encodeObject:self.epub_all forKey:BookEpubAll];
    [aCoder encodeObject:self.epub_unall forKey:BookEpubUnAll];
}

-(id)initWithCoder:(NSCoder*)decoder{
    if (self = [super init]) {
        self.bookId = [[decoder decodeObjectForKey:BookId] integerValue];
        self.bookImage = [decoder decodeObjectForKey:BookImage];
        self.bookName = [decoder decodeObjectForKey:BookName];
        self.bookAuthor = [decoder decodeObjectForKey:BookAuthor];
        self.bookDate = [decoder decodeObjectForKey:BookDate];
        self.bookPrice = [[decoder decodeObjectForKey:BookPrice] floatValue];
        self.bookThumb = [decoder decodeObjectForKey:BookThumb];
        self.bookBrief = [decoder decodeObjectForKey:BookBrief];
        self.bookClickCount = [[decoder decodeObjectForKey:BookBrief] integerValue];
        self.epub_all = [decoder decodeObjectForKey:BookEpubAll];
        self.epub_unall = [decoder decodeObjectForKey:BookEpubUnAll];
    }
    return self;
}
-(NSString *)description{
    return ([NSString stringWithFormat:@"bookInfo:\n bookid:%d\n bookName:%@\n bookAuthor:%@\n bookDate:%@\n bookPrice:%f\n bookImage:%@\n bookThumb:%@\n bookBrief:%@\n bookClichCount:%d\n epub_all:%@\n epub_unall%@\n",_bookId,_bookName,_bookAuthor,_bookDate,_bookPrice,_bookImage,_bookThumb,_bookBrief,_bookClickCount,_epub_all,_epub_unall]);
}
@end
