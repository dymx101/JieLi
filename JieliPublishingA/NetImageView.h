//
//  NetImageView.h
//  aabb
//
//  Created by 花 晨 on 13-4-18.
//  Copyright (c) 2013年 中卡. All rights reserved.
//

#import <UIKit/UIKit.h>
//operation委托方法
@protocol ImageOperationDelegate <NSObject>
-(void)ImageOprationFinish:(id)result;

@end
//自定义operation类
@interface ImageOperation : NSOperation{
    NSString *urlString;
}
@property (strong) id<ImageOperationDelegate> delegate;
-(id)initWithUrl:(NSString *)url;
@end

@class NetImageView;
@protocol NetImageViewDelegate <NSObject>
@optional
-(void)NetImageViewActive:(NetImageView *)netImageView;
-(void)NetImageViewFinish:(NetImageView *)netImageView;
-(void)NetImageViewFail:(NetImageView *)netImageView;


@end

typedef enum {
    NetImageViewActive,
    NetImageViewFinish,
    NetImageViewFail
}NetImageViewState;

//自定义uiimageview
@interface NetImageView : UIImageView<ImageOperationDelegate>{
    NetImageViewState netImageState;
}
@property (nonatomic,readonly,assign) NetImageViewState netImageState;
@property (nonatomic,assign) id<NetImageViewDelegate>delegate;
@property (nonatomic,strong) NSString *userInfo;
+(id)NetImageViewWithUrl:(NSString*)url;
+(id)NetImageViewWithUrl:(NSString*)url withTarget:(id)target;

@end
