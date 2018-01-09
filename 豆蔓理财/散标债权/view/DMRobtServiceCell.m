//
//  DMRobtServiceCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/17.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtServiceCell.h"
#import "MenuButton.h"
@interface DMRobtServiceCell ()<MenuButtonDelegate>

@property (nonatomic, strong)UIView *bottomView;
@property (nonatomic, strong)MenuButton *menuButton;
@end

@implementation DMRobtServiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.menuButton];
    }
    return self;
}


- (MenuButton *)menuButton{
    if (!_menuButton) {
        self.menuButton = [[MenuButton alloc] initWithFrame:CGRectMake(0, 0, DMDeviceWidth - 40, 44) TitleArray:@[@"服务介绍",@"加入列表"] SelectColor:UIColorFromRGB(0x00c79f) UnselectColor:UIColorFromRGB(0x4b5159)];
        _menuButton.delegate = self;
    }
    return _menuButton;
}

- (void)selectButtonWithIndex:(NSInteger)index{
    !self.touchSegment ? : self.touchSegment(index);
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, DMDeviceWidth - 40, 44)];
        _bottomView.backgroundColor = UIColorFromRGB(0xffffff);
        
    }
    return _bottomView;
}

- (UIView *)createSegmentView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(40, 20, DMDeviceWidth - 120, 40)];
    headerView.backgroundColor = UIColorFromRGB(0xffffff);
    headerView.layer.cornerRadius = 18;
    headerView.layer.borderColor = UIColorFromRGB(0xf3f3f3).CGColor;
    headerView.layer.borderWidth = 1;
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"服务介绍",@"加入列表"]];
    [segmentedControl setFrame:CGRectMake(0, 0, DMDeviceWidth - 80 - 40, 40)];
    segmentedControl.layer.cornerRadius = 18;
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.tintColor = [UIColor whiteColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                             NSForegroundColorAttributeName: [UIColor whiteColor]};
    [segmentedControl setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];//设置文字属性
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],
                                               NSForegroundColorAttributeName: UIColorFromRGB(0x878787)};
    [segmentedControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    [segmentedControl setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xffffff)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [segmentedControl setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xffae00)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    segmentedControl.apportionsSegmentWidthsByContent = NO;
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(serviceAndJoinList:) forControlEvents:(UIControlEventValueChanged)];
    
    [headerView addSubview:segmentedControl];
    return headerView;
}

- (void)serviceAndJoinList:(UISegmentedControl *)segment {
    !self.touchSegment ? : self.touchSegment(segment.selectedSegmentIndex);
}

- (UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, (DMDeviceWidth - 120) / 2, 40.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
