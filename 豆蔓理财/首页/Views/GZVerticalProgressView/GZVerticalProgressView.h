//
//  GZVerticalProgressView.h
//  demo
//
//  Created by armada on 2016/11/30.
//  Copyright © 2016年 edz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZVerticalProgressView : UIView

/*!
 * @breif initilizer
 * @param frame The origin and size of CZVerticalProgressView
 * @param values The number of every portion in the progress
 * @param colors The color of every portion in the progress
 * @param contents The value of every portion
 * @param titles The explanation of every portion
 * @return The instance of GZVerticalProgressView
 */

- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values colors:(NSArray *)colors contents:(NSArray *)contents titles:(NSArray *)titles;


@end
