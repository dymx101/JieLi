//
//  NetImageView.m
//  aabb
//
//  Created by 花 晨 on 13-4-18.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import "NetImageView.h"
#define ImageCache @"ImageCache"
static NSOperationQueue *queue;


@implementation ImageOperation
//维持一个队列的静态变量
+(NSOperationQueue *)shareQueue{
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:5];
    }
    return queue;
}
//初始化
-(id)initWithUrl:(NSString *)url{
    if (self = [super init]) {
        urlString = [NSString stringWithString:url];
        [urlString retain];
    }
    return self;
}

//提取文件名
+(NSString *)getFileNameWithUrlPath:(NSString *)urlPath{
    int lastSlash = [urlPath rangeOfString:@"/" options:NSBackwardsSearch].location;
	return [urlPath substringFromIndex:(lastSlash +1)];
}

//会在此operation加入队列后开始
-(void)main{
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    if (!image) {
        return;
    }
    //回归主线程
    [[self class] writeFile:data withImageUrl:[[self class] getFileNameWithUrlPath:urlString]];
    [self performSelectorOnMainThread:@selector(finish:) withObject:image waitUntilDone:NO];
}
//委托过去
-(void)finish:(UIImage *)image{
    [self.delegate ImageOprationFinish:image];
}
+(void)writeFile:(NSData*)file withImageUrl:(NSString *)imageUrl{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取路径
    //1、参数NSDocumentDirectory要获取的那种路径
    NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //2、得到相应的Documents的路径
    NSString* DocumentDirectory = [paths objectAtIndex:0];
    //*新建文件夹
    NSString* myFolder = [DocumentDirectory stringByAppendingPathComponent:ImageCache];
    [fileManager createDirectoryAtPath:myFolder withIntermediateDirectories:NO attributes:nil error:nil];
    //3、更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[DocumentDirectory stringByExpandingTildeInPath]];
    //4、创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
    NSString *fileName = imageUrl;
    [fileManager removeItemAtPath:fileName error:nil];
    NSString *path = [myFolder stringByAppendingPathComponent:fileName];
    //5、创建数据缓冲区
    NSMutableData  *writer = [[NSMutableData alloc] init];
    //6、将字符串添加到缓冲中
    [writer appendData:file];
    //7、将其他数据添加到缓冲中
    //将缓冲的数据写入到文件中
    [writer writeToFile:path atomically:YES];
    [writer release];
    writer = nil;
}

@end



@implementation NetImageView

-(NetImageViewState)netImageState{
    return netImageState;
}

//初始化方法
+(id)NetImageViewWithUrl:(NSString*)url{
    return [[self alloc] initWithUrl:url withTarget:nil];
}
+(id)NetImageViewWithUrl:(NSString*)url withTarget:(id)target{
    return [[self alloc] initWithUrl:url withTarget:target];
}

-(id)initWithUrl:(NSString *)url withTarget:(id)target{
    if (self = [super init]) {
        self.delegate = target;
        netImageState = NetImageViewActive;
        if ([self.delegate respondsToSelector:@selector(NetImageViewActive:)]) {
            [self.delegate NetImageViewActive:self];

        }
        NSString *urlName = [[ImageOperation class] getFileNameWithUrlPath:url];
        NSData *data = [[self class] readFilewithImageUrl:urlName];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
//            [self performSelectorOnMainThread:@selector(finish:) withObject:image waitUntilDone:NO];
            [self setImage:image];
            netImageState = NetImageViewFinish;
            if ([self.delegate respondsToSelector:@selector(NetImageViewFinish:)]) {
                [self.delegate NetImageViewFinish:self];
            }
        }
        else{
            if (url == nil) {
                netImageState = NetImageViewFail;
                if ([self.delegate respondsToSelector:@selector(NetImageViewFail:)]) {
                    [self.delegate NetImageViewFail:self];
                }
            }
            else{
                NSLog(@"从网络下载图片，url:%@",url);
                //新建一个任务
                ImageOperation *io = [[ImageOperation alloc] initWithUrl:url];
                io.delegate = self;
                [[ImageOperation shareQueue] addOperation:io];
            }
        }

    }
    return self;
}
#pragma mark--
#pragma ImageOperationDelegate
//ImageOperationDelegate方法
-(void)ImageOprationFinish:(UIImage *)image{
    [self setImage:image];
    netImageState = NetImageViewFinish;
    if ([self.delegate respondsToSelector:@selector(NetImageViewFinish:)]) {
        [self.delegate NetImageViewFinish:self];
    }
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, image.size.width, image.size.height);
}
+(NSData *)readFilewithImageUrl:(NSString *)imageUrl
{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* myFolder = [documentsDirectory stringByAppendingPathComponent:ImageCache];
    
    [fileManager changeCurrentDirectoryPath:[myFolder stringByExpandingTildeInPath]];
    
    //获取文件路劲
    NSString *fileName = imageUrl;
    
    if (!fileName) {
        return nil;
    }
    else{
        NSString* path = [myFolder stringByAppendingPathComponent:fileName];
        NSData* reader = [NSData dataWithContentsOfFile:path];
        return reader;
    }
    
}

@end
