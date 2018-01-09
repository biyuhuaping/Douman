//
//  GZFilteredProtocol.m
//  豆蔓理财
//
//  Created by armada on 2017/5/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "GZFilteredProtocol.h"

@implementation GZFilteredProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    //    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    //只处理http和https请求
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:FilteredCssKey inRequest:request])
            return NO;
        
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    
    //会打印所有的请求链接包括css和ajax请求等
    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    
//    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    
//    if ([request.HTTPMethod isEqualToString:@"GET"]) {
//        
//    }else if ([request.HTTPMethod isEqualToString:@"POST"]){
//        
//        NSString *userId = [NSString stringWithFormat:@"userId=%@",USER_ID];
//        
//        mutableReqeust.HTTPBody = [userId dataUsingEncoding:NSUTF8StringEncoding];
//    }

//     NSString *url = [[NSString alloc] initWithData:mutableReqeust.HTTPBody encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",url);
    
    //截取重定向
    return request;
}

+ (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    
    if ([request.URL host].length == 0) {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    //定向到bing搜索主页
    NSString *ip = @"cn.bing.com";
    
    // 替换域名
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ip];
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
- (void)startLoading
{
    
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:FilteredCssKey inRequest:mutableReqeust];

    self.connection = [NSURLConnection connectionWithRequest:mutableReqeust delegate:self];

}

- (void)stopLoading
{
    
    if (self.connection != nil)
    {
        [self.connection cancel];
        self.connection = nil;
    }
}

#pragma mark- NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseData = [[NSMutableData alloc] init];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
    [self.client URLProtocol:self didLoadData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self.client URLProtocolDidFinishLoading:self];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    
    if (response != nil)
    {
        [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    return request;
}

@end
