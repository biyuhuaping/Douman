//
//  NSURLRequest+SSL.h
//  豆蔓理财
//
//  Created by armada on 2017/5/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (SSL)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host;

@end
