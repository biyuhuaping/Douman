//
//  GZFilteredProtocol.h
//  豆蔓理财
//
//  Created by armada on 2017/5/26.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSString*const FilteredCssKey = @"filteredCssKey";
@interface GZFilteredProtocol : NSURLProtocol

@property (nonatomic, strong) NSMutableData   *responseData;

@property (nonatomic, strong) NSURLConnection *connection;

+ (BOOL)canInitWithRequest:(NSURLRequest *)request;

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request;

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b;

- (void)startLoading;

- (void)stopLoading;

@end
