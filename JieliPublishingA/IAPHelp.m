//
//  IAPHelp.m
//  LearnInApp
//
//  Created by HuaChen on 13-5-6.
//  Copyright (c) 2013年 HuaChen. All rights reserved.
//

#import "IAPHelp.h"
#import "NSData+Base64.h"
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface IAPHelp ()
@end

@implementation IAPHelp
-(void)dealloc{
    [super dealloc];
    _request = nil;
    _productIdentifiers = nil;
    _products = nil;
    _purchasedProducts = nil;
}


-(id)initWithProductIdentifiers:(NSSet *)productIdentifiers{
    if ((self = [super init])) {
    _productIdentifiers = productIdentifiers;
        
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    if ([SKPaymentQueue canMakePayments]) {
        // 执行下面提到的第5步：
//        [self getProductInfo];
    } else {
        NSLog(@"失败，用户禁止应用内付费购买.");
        
    }

    
    NSMutableSet *purchasedProducts = [NSMutableSet set];
    for (NSString *productIdentifier in _productIdentifiers) {
        BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
        if (productPurchased) {
            [purchasedProducts addObject:productIdentifier];
            NSLog(@"已经购买:%@",productIdentifier);
        }
        else{
        NSLog(@"没有购买:%@",productIdentifier);
        }
    }
    self.purchasedProducts = purchasedProducts;
}
    return self;
}

static bool newBuy;
#pragma 查询产品
-(void)requestProducts{
    newBuy = YES;
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _request.delegate = self;
    [_request start];
}

#pragma 查询产品的回调函数
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    self.products = [[NSArray alloc] initWithArray:response.products];
    self.request = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
//    SKPayment * payment = [SKPayment paymentWithProduct:_products[0]];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

- (void)buyProductIdentifier:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
//    product.productIdentifier;
    
    
    if ([self.purchasedProducts containsObject:product.productIdentifier]) {
        UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"" message:@"您已购买过此书" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles: nil];
        [al show];
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

        return;
    }
    
    
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}

- (void)provideContent:(NSString *)productIdentifier {
    
    NSLog(@"Toggling flag for: %@", productIdentifier);
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    [_purchasedProducts addObject:productIdentifier];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:productIdentifier];
    
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

    
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

    [self provideContent: transaction.payment.productIdentifier];
    
    NSString *json = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}",receipt];
    NSData *data = [json dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString *postLength = [NSString stringWithFormat:@"%d",[json length]];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *sandboxStoreURL = [[NSURL alloc] initWithString: @"https://sandbox.itunes.apple.com/verifyReceipt"];
        [request setURL:sandboxStoreURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        //设置http-header:Content-Length
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        //设置需要post提交的内容
        [request setHTTPBody:data];
        
        
        NSHTTPURLResponse* urlResponse = nil;
        NSError *error = [[NSError alloc] init];
        //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        //将NSData类型的返回值转换成NSString类型
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"user login check result:%@",result);
    }
    
    
    // Remove the transaction from the payment queue.
    
}
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

}
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];


}


@end
