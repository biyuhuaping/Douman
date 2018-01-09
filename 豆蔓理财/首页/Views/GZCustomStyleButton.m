//
//  GZCustomStyleButton.m
//  豆蔓理财
//
//  Created by armada on 2016/12/15.
//  Copyright © 2016年 edz. All rights reserved.
//

#import "GZCustomStyleButton.h"

@implementation GZCustomStyleButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    if(!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    if(!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}

@end
