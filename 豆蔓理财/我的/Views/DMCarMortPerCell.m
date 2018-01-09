//
//  DMCarMortPerCell.m
//  zhaiquanxiangqing
//
//  Created by wujianqiang on 2016/12/13.
//  Copyright © 2016年 wujianqiang. All rights reserved.
//

#import "DMCarMortPerCell.h"
#import "DMPerCheckCollectionCell.h"



@interface DMCarMortPerCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;


@end

@implementation DMCarMortPerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 30, DMDeviceWidth-20, 90) collectionViewLayout:flowLayOut];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        flowLayOut.sectionInset = UIEdgeInsetsMake(0,0,0,0);
        flowLayOut.minimumInteritemSpacing = 0;
        flowLayOut.minimumLineSpacing = 0;
        [_collectionView registerClass:[DMPerCheckCollectionCell class] forCellWithReuseIdentifier:@"DMPerCheckCollectionCell"];
        
    }
    return _collectionView;
}

#pragma mark collectionView delegate & datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(DMDeviceWidth/2-10, 30);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DMPerCheckCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DMPerCheckCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
//    cell.typeImage.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    cell.typeLabel.text = self.dataArray[indexPath.row];
    if ([self.authenArray[indexPath.row] isEqualToString:@"1"]) {
        cell.isPass.image = [UIImage imageNamed:@"certification_ok_icon"]; ////////////////审核通过
    }else{
        cell.isPass.image = [UIImage imageNamed:@"certification_no_icon"]; ////////////审核未通过
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSArray *)dataArray{
    if (_dataArray == nil) {
        self.dataArray = [@[] copy];
    }
    return _dataArray;
}

- (NSArray *)authenArray{
    if (_authenArray == nil) {
        self.authenArray = [@[] copy];
    }
    return _authenArray;
}


- (void)drawRect:(CGRect)rect{
    CGFloat n = self.dataArray.count%2==0?(self.dataArray.count/2):(self.dataArray.count + 1)/2;
    CGFloat h = 30;
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(10, 30, DMDeviceWidth-20,h*n)];
    for (int i = 0 ; i < n-1; i ++) {
        [path moveToPoint:CGPointMake(10, 60+h*i)];
        [path addLineToPoint:CGPointMake(DMDeviceWidth-10, 60+h*i)];
    }
    [path moveToPoint:CGPointMake(DMDeviceWidth/2, 30)];
    [path addLineToPoint:CGPointMake(DMDeviceWidth/2, 30+h*n)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; ////////////121b2c
    layer.strokeColor = UIColorFromRGB(0xe6e6e6).CGColor; //////////////1d293f
    layer.lineWidth = 0.5;
    [self.contentView.layer addSublayer:layer];
    [self.contentView addSubview:self.collectionView];
}

@end
