//
//  DataBrain.m
//  JieliPublishingA
//
//  Created by 花 晨 on 12-11-22.
//  Copyright (c) 2012年 中卡. All rights reserved.
//

#import "DataBrain.h"

//#define BaseURL @"http://188.188.188.104/jieli/webs.php"



@implementation DataBrain
@synthesize getListDelegate = _getListDelegate;
+(void)writeFile:(NSData*)file withIndex:(int)dataIndex withFlolderName:(NSString *)myFloderName
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取路径
    //1、参数NSDocumentDirectory要获取的那种路径
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //2、得到相应的Documents的路径
    NSString* DocumentDirectory = [paths objectAtIndex:0];
    //*新建文件夹
    NSString* myFolder = [DocumentDirectory stringByAppendingPathComponent:myFloderName];
    [fileManager createDirectoryAtPath:myFolder withIntermediateDirectories:NO attributes:nil error:nil];
    //3、更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
    //4、创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    NSString *fileName = [NSString stringWithFormat:@"%d.png",dataIndex];
    [fileManager removeItemAtPath:fileName error:nil];
    NSString *path = [myFolder stringByAppendingPathComponent:fileName];
    //5、创建数据缓冲区
    NSMutableData  *writer = [[NSMutableData alloc] init];
    //6、将字符串添加到缓冲中
    [writer appendData:file];
    //7、将其他数据添加到缓冲中 
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
}
+(NSData *)readFilewithImageId:(int)imageId  withFlolderName:(NSString *)myFloderName
{
    NSLog(@"readFile @:%@  imageId:%d",myFloderName,imageId);
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* myFolder = [documentsDirectory stringByAppendingPathComponent:myFloderName];

    [fileManager changeCurrentDirectoryPath:[myFolder stringByExpandingTildeInPath]];
    
    //获取文件路劲
    NSString *fileName = [NSString stringWithFormat:@"%d.png",imageId];
    
    if (!fileName) {
        return nil;
    }
    else{
        NSString* path = [myFolder stringByAppendingPathComponent:fileName];
        NSData* reader = [NSData dataWithContentsOfFile:path];
        return reader;
    }
    
}

#pragma mark -
#pragma mark 接力好书
-(NSArray *)newBookArray{
    if (!_newBookArray) {
        _newBookArray = [[NSArray alloc] init];
    }
    return _newBookArray;
}
-(NSArray *)marketableArray{
    if (!_marketableArray) {
        _marketableArray = [[NSArray alloc] init];
    }
    return _marketableArray;
}
-(NSArray *)competitiveArray{
    if (!_competitiveArray) {
        _competitiveArray = [[NSArray alloc] init];
    }
    return _competitiveArray;
}
-(NSArray *)categoriesArray{
    if (!_categoriesArray) {
        _categoriesArray = [[NSArray alloc] init];
    }
    return _categoriesArray;
}



-(NSArray *)categorieListArray{
    if (!_categorieListArray) {
        _categorieListArray = [[NSArray alloc] init];
    }
    return _categorieListArray;
}

-(void)finishGetBookListwithArray:(NSMutableArray *)array {
    NSNumber *typeNumber = [array lastObject];
    int type = [typeNumber intValue];
    [array removeLastObject];
    switch (type) {
        case DownListTypeOfNewBook:
            self.newBookArray = [[NSArray alloc] initWithArray:[self.newBookArray arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.newBookArray withType:DownListTypeOfNewBook];
            break;
            
        case DownListTypeOfMarketable:
            self.marketableArray = [[NSArray alloc] initWithArray:[self.marketableArray arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.marketableArray withType:DownListTypeOfMarketable];
            break;
            
        case DownListTypeOfCompetitive:
            self.competitiveArray = [[NSArray alloc] initWithArray:[self.competitiveArray arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.competitiveArray withType:DownListTypeOfCompetitive];
            break;
            
        case DownListTypeOfCategories:
            self.categoriesArray = [[NSArray alloc] initWithArray:array];
            [self.getListDelegate finishGetListWithArray:self.categoriesArray withType:DownListTypeOfCategories];
            break;
            
        case DownListTypeOfCategorieList:
            self.categorieListArray = [[NSArray alloc] initWithArray:[self.categorieListArray arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.categorieListArray withType:DownListTypeOfCategorieList];
            break;
        case DownListTypeOfSearch:
            self.searchArray = [[NSArray alloc] initWithArray:[self.searchArray arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.categorieListArray withType:DownListTypeOfSearch];
            break;
        case DownListTypeOfPromotionList:
            self.promotionList = [[NSArray alloc] initWithArray:[self.promotionList arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.promotionList withType:DownListTypeOfPromotionList];
            break;
       case DownListTypeOfActiviey:
            self.ActivityList = [[NSArray alloc] initWithArray:[self.ActivityList arrayByAddingObjectsFromArray:array]];
            [self.getListDelegate finishGetListWithArray:self.ActivityList withType:DownListTypeOfActiviey];
            break;
        case DownListTypeOfCraw:
            [self.getListDelegate finishGetListWithArray:array withType:DownListTypeOfCraw];
            break;
        default:
            break;
    }

}

-(void)downMoreBookListWithUrl:(NSString *)urlString OfType:(int)type{
    NSLog(@"从网络获取图书列表");
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSLog(@"%@",url);
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            id result =[NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions error:&error];
            NSLog(@"%@",result);
            if (!result) {
                NSLog(@"获取列表为空");
                return;
            }
            NSMutableArray *array = [NSMutableArray arrayWithArray:[BookInfo bookInfoWithJSON:result]];
//            for (NSDictionary *dic in result) {
//                BookInfo *bookInfo = [BookInfo bookInfoWithBookId:[[dic objectForKey:@"bookId"] intValue]
//                                                     withBookName:[dic objectForKey:@"bookName"]
//                                                   withBookAuthor:[dic objectForKey:@"bookAuthor"]
//                                                     withBookDate:[dic objectForKey:@"bookDate"]
//                                                    withBookPrice:[[dic objectForKey:@"bookPrice"] floatValue]
//                                                    withBookImage:[dic objectForKey:@"bookImage"]
//                                                    withBookThumb:[dic objectForKey:@"bookThumb"]
//                                                    withBookBrief:[dic objectForKey:@"bookBrief"]
//                                               withBookClickCount:[[dic objectForKey:@"bookClickCount"] intValue]
//                                      
//                                      ];
//                [array addObject:bookInfo];
//            }
            NSLog(@"获取列表成功。");
            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(finishGetBookListwithArray:) withObject:array waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];
}

//得到最新上架列表
-(void)getMoreNewBookList{
    int start = [self.newBookArray count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getNewBookList&start=%d&amount=6",start];
    [self downMoreBookListWithUrl:urlString OfType:DownListTypeOfNewBook];
}
//得到精品图书列表
-(void)getMarketableBookList{
    int start = [self.marketableArray count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getMarketableBookList&start=%d&amount=6",start];
    [self downMoreBookListWithUrl:urlString OfType:DownListTypeOfMarketable];
}
//得到畅销书榜列表
-(void)getCompetitiveBookList{
    int start = [self.competitiveArray count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getCompetitiveBookList&start=%d&amount=6",start];
    [self downMoreBookListWithUrl:urlString OfType:DownListTypeOfCompetitive];
}
//得到图书分类子类列表
-(void)getCategorieList:(int)categoryid{
    int start = [self.categorieListArray count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getCategoryBookList&categoryId=%d&start=%d&amount=6",categoryid,start];
    [self downMoreBookListWithUrl:urlString OfType:DownListTypeOfCategorieList];
}
 



//得到图书分类表
-(void)getBookCategories{
//    int start = [self.competitiveArray count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getBookCategories"];
    [self downCategoriesWithUrl:urlString OfType:DownListTypeOfCategories];
}

-(void)downCategoriesWithUrl:(NSString *)urlString OfType:(int)type{
    NSLog(@"从网络获取图书分类列表");
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            id result =[NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions error:&error];
            NSMutableArray *array = [NSMutableArray arrayWithArray:result];
            NSLog(@"获取图书分类列表成功。");
            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(finishGetBookListwithArray:) withObject:array waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];
}
#pragma mark -
#pragma matk 促销优惠

-(NSArray *)promotionList{
    if (!_promotionList) {
        _promotionList = [[NSArray alloc] init];
    }
    return _promotionList;
}

-(void)getPromotionList{
    int start = [self.promotionList count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Promotion&m=getPromotionList&start=%d&amount=10",start];
    [self downPromotionListWithUrl:urlString OfType:DownListTypeOfPromotionList];
}

-(void)downPromotionListWithUrl:(NSString *)urlString OfType:(int)type{
    NSLog(@"从网络获取促销优惠列表");
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            id result =[NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions error:&error];
            NSMutableArray *array = [NSMutableArray arrayWithArray:result];
            NSLog(@"获取促销优惠列表成功。");
            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(finishGetBookListwithArray:) withObject:array waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];
}
#pragma mark -
#pragma matk 读书活动

-(NSArray *)ActivityList{
    if (!_ActivityList) {
        _ActivityList = [[NSArray alloc] init];
    }
    return _ActivityList;
}

-(void)getActivityList{
    int start = [self.ActivityList count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Activity&m=getNewActivityList&start=%d&amount=10",start];
    [self downActivityListWithUrl:urlString OfType:DownListTypeOfActiviey];

}

-(void)downActivityListWithUrl:(NSString *)urlString OfType:(int)type{
    NSLog(@"从网络获取读书活动列表");
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            id result =[NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions error:&error];
            NSMutableArray *array = [NSMutableArray arrayWithArray:result];
            NSLog(@"%@",array);
            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(finishGetBookListwithArray:) withObject:array waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];
}





#pragma mark -
#pragma matk 搜索
-(void)getSearchBookList:(NSString *)key{
//    int start = [self.searchArray count];
    NSString *urlString = [NSString stringWithFormat:@"?c=Book&m=getSearchBookList&keyWord=%@",key];
    [self downMoreBookListWithUrl:urlString OfType:DownListTypeOfSearch];
}
#pragma mark -
#pragma matk 图书买手
-(void)getCrawlList:(int)bookId{
    NSString *urlString = [NSString stringWithFormat:@"?c=admin&m=getCrawl&bookid=%d",bookId];
    [self downCrawListWithUrl:urlString OfType:DownListTypeOfCraw];
}
-(void)downCrawListWithUrl:(NSString *)urlString OfType:(int)type{
    NSURL *url = [NSURL URLWithString:[[BaseURL stringByAppendingString:urlString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 &&error == nil) {
            id result =[NSJSONSerialization JSONObjectWithData:data
                                                       options:kNilOptions error:&error];
            NSLog(@"%@",result);
            NSMutableArray *array = nil;

            NSDictionary *dic = result;
            
            if ([dic count]==2) {
                NSString *key = [dic objectForKey:@"result"];
                
                if (key&&[key isEqualToString:@"0"]) {
                    array = [[NSMutableArray alloc] init];
                }
                else{
                    array = [[NSMutableArray alloc] initWithArray:result];
                }

            }
            NSNumber *typeNumber = [NSNumber numberWithInt:type];
            [array addObject:typeNumber];
            [self performSelectorOnMainThread:@selector(finishGetBookListwithArray:) withObject:array waitUntilDone:NO];
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"没有东西被下载。"); }
        else if (error != nil){
            NSLog(@"发生错误 = %@", error);
            
        }
    }];
}


@end
