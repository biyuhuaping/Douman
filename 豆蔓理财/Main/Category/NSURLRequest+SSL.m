//
//  NSURLRequest+SSL.m
//  豆蔓理财
//
//  Created by armada on 2017/5/27.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "NSURLRequest+SSL.h"

@implementation NSURLRequest (SSL)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

+(void)setAllowsAnyHTTPSCertificate:(BOOL)allow forHost:(NSString*)host
{
    
}
@end
