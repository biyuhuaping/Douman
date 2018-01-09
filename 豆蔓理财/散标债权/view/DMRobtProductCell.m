//
//  DMRobtProductCell.m
//  豆蔓理财
//
//  Created by edz on 2017/7/14.
//  Copyright © 2017年 edz. All rights reserved.
//

#import "DMRobtProductCell.h"
#import "DMRobtCollectionCell.h"
#import "DMRobtOpenInfoModel.h"
#import "DMRobtOpeningModel.h"
#define robtScale (DMDeviceWidth - 24) / 368

#define SPACE 3
@interface DMRobtProductCell ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

//背景图层
@property (nonatomic, strong)UIImageView *bottomView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)UILabel *productNameLabel;
@property (nonatomic, strong)UILabel *rateLabel;
@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *otherBotView;
@property (nonatomic, strong)CustomTextField *customTextField;
@property (nonatomic, strong)UILabel *openLabel;
@property (nonatomic, strong)UILabel *closeLabel;
@property (nonatomic, assign)NSInteger selectedIndex;

@property (nonatomic, strong)UIButton *serviceButton;


@property (nonatomic, assign)NSInteger selectedMonth;

@property (nonatomic, strong) UILabel *warnLabel;

@end

static NSString *const collectionIdentifier = @"DMRobtCollectionCellIdentifier";
@implementation DMRobtProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf3f3f3);
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.productNameLabel];
        [self.bottomView addSubview:self.rateLabel];
        [self.bottomView addSubview:self.timeLabel];
       
        [self.bottomView addSubview:self.serviceButton];
        
        [self.contentView addSubview:self.otherBotView];
        [self.otherBotView addSubview:self.customTextField];
        [self.otherBotView addSubview:self.openLabel];
        [self.otherBotView addSubview:self.closeLabel];
        [self.otherBotView addSubview:self.joinButton];
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        if (interval > 1502640000) {
            
        }else{
            [self.otherBotView addSubview:self.warnLabel];
        }

        [self.contentView bringSubviewToFront:self.bottomView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chagnebuttonImage:) name:@"changebtnstatus" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chagnebuttonImage:) name:@"TimeInvalidate" object:nil];

    }
    
    return self;
}

- (void)chagnebuttonImage:(NSNotification *)notification {
    if ([notification.name isEqualToString:@"changebtnstatus"]) {
        self.openModel.saleStatus = @"2";
    }else if ([notification.name isEqualToString:@"TimeInvalidate"]) {
        [self.joinButton setImage:[UIImage imageNamed:@"robotToJoin"] forState:(UIControlStateNormal)];
        [self.joinButton setUserInteractionEnabled:YES];
    }else{
        return;
    }
}

- (void)setInfoArr:(NSMutableArray *)infoArr {
    if (_infoArr != infoArr) {
        _infoArr = infoArr;
    }
    [self.bottomView addSubview:self.collectionView];
    [self.collectionView reloadData];
}

- (void)setSelectedGuarantyStyle:(NSString *)SelectedGuarantyStyle {
    if (_SelectedGuarantyStyle != SelectedGuarantyStyle) {
        _SelectedGuarantyStyle = SelectedGuarantyStyle;
    }
    
    [self.infoArr enumerateObjectsUsingBlock:^(DMRobtOpenInfoModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.robotCycle integerValue] == [_SelectedGuarantyStyle integerValue]) {
            self.selectedIndex = idx;
        }
    }];
    
    [self.collectionView reloadData];
}


- (void)setOpenModel:(DMRobtOpeningModel *)openModel {
    if (_openModel != openModel) {
        _openModel = openModel;
    }
    self.productNameLabel.text = [NSString stringWithFormat:@"%@号",isOrEmpty(_openModel.robotNumber) ? @"--" : _openModel.robotNumber];
   // NSArray *openArr = [_openModel.openingTime componentsSeparatedByString:@" "];
    self.openLabel.text = [NSString stringWithFormat:@"开放时间：%@",isOrEmpty(_openModel.openingTime) ? @"-" : _openModel.openingTime];
    //NSArray *endArr = [_openModel.endTime componentsSeparatedByString:@" "];
    self.closeLabel.text = [NSString stringWithFormat:@"结束时间：%@",isOrEmpty(_openModel.endTime) ? @"-" : _openModel.endTime];
    
    UIImage *image = [UIImage imageNamed:@"robtNotStart"];
    if ([_openModel.saleStatus isEqualToString:@"0"]) {
        //未开始
        [self.joinButton setImage:[UIImage imageNamed:@"robtNotStart"] forState:(UIControlStateNormal)];
        [self.joinButton setUserInteractionEnabled:NO];
        [_joinButton setFrame:CGRectMake((DMDeviceWidth - 60) / 2 - image.size.width / 2, 100 + 35 + 12, image.size.width, image.size.height)];
        self.warnLabel.hidden = NO;
    }else if ([_openModel.saleStatus isEqualToString:@"1"]) {
        //已开始
        [self.joinButton setImage:[UIImage imageNamed:@"robotToJoin"] forState:(UIControlStateNormal)];
        [self.joinButton setUserInteractionEnabled:YES];
        [_joinButton setFrame:CGRectMake((DMDeviceWidth - 60) / 2 - image.size.width / 2, 100 + 35 , image.size.width, image.size.height)];
        self.warnLabel.hidden = YES;
    }else {
        //已结束
        [_joinButton setFrame:CGRectMake((DMDeviceWidth - 60) / 2 - image.size.width / 2, 100 + 35, image.size.width, image.size.height)];
        [self.joinButton setImage:[UIImage imageNamed:@"robtFinsh"] forState:(UIControlStateNormal)];
        [self.joinButton setUserInteractionEnabled:NO];
        self.warnLabel.hidden = YES;
        self.openLabel.text = [NSString stringWithFormat:@"开放时间：--"];
        self.closeLabel.text = [NSString stringWithFormat:@"结束时间：--"];
    }
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
    if (interval > 1502640000) {
        [_joinButton setFrame:CGRectMake((DMDeviceWidth - 60) / 2 - image.size.width / 2, 100 + 35, image.size.width, image.size.height)];
    }else{
        
    }

    self.customTextField.placeholder = [NSString stringWithFormat:@"请输入%@整数倍的金额",_openModel.minPurchaseAmount];
}

#pragma collectionViewDelegate && dataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake(100, 90 * robtScale);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    DMRobtCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionIdentifier forIndexPath:indexPath];
    DMRobtOpenInfoModel *model = self.infoArr[indexPath.row];
    cell.infoModel = model;
    if (self.selectedIndex == indexPath.row) {
        cell.isSelected = YES;
    }else {
        cell.isSelected = NO;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.infoArr.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
//    [collectionView reloadData];
    DMRobtOpenInfoModel *model = self.infoArr[indexPath.row];
    !self.selectedCycle ? : self.selectedCycle([model.robotCycle integerValue]);
}

#pragma touchEvent

/**
 立即加入
 */
- (void)immediatelyJoin:(UIButton *)sender {
    if (isOrEmpty(self.customTextField.text)) {
        !self.robtJoin ? : self.robtJoin(@"请输入购买金额");
    }else {
        !self.robtJoin ? : self.robtJoin(self.customTextField.text);
    }
    
}

//查看往期服务
- (void)lookPastService {
    !self.pastService ? : self.pastService();
}


/**
 编辑改变
 */
- (void)stringLengthChange:(CustomTextField *)textField {
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.customTextField resignFirstResponder];
    return YES;
}


#pragma lazyLoading 

- (UIImageView *)bottomView {
    UIImage *image = [UIImage imageNamed:@"robtBottomView"];
    if (!_bottomView) {
        _bottomView = [[UIImageView alloc] initWithImage:image];
        [_bottomView setFrame:CGRectMake(12, 12, DMDeviceWidth - 24, (DMDeviceWidth - 24) * image.size.height / image.size.width)];
        _bottomView.userInteractionEnabled = YES;
    }
    return _bottomView;
}

//产品名称
- (UILabel *)productNameLabel {
    if (!_productNameLabel) {
        _productNameLabel = [UILabel createLabelFrame:CGRectMake(0, 14, DMDeviceWidth - 24, 16) labelColor:UIColorFromRGB(0x41526f) textAlignment:(NSTextAlignmentCenter) textFont:15.f];
        _productNameLabel.text = @"小豆机器人17062704号";
    }
    return _productNameLabel;
}

- (UILabel *)rateLabel {
    if (!_rateLabel) {
        _rateLabel = [UILabel createLabelFrame:CGRectMake(20, 70 * robtScale, 70, 12) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _rateLabel.text = @"预计年化利率";
    }
    return _rateLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel createLabelFrame:CGRectMake(20, 82 + 27 * robtScale, 50, 12) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _timeLabel.text = @"服务周期";
    }
    return _timeLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        flowLayOut.minimumLineSpacing = 8;
        flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(90, 45, DMDeviceWidth - 130, 90 * robtScale) collectionViewLayout:flowLayOut];
        [_collectionView registerClass:[DMRobtCollectionCell class] forCellWithReuseIdentifier:collectionIdentifier];
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;

    }
    return _collectionView;
}

- (UIView *)otherBotView {
    UIImage *image = [UIImage imageNamed:@"robtBottomView"];
    if (!_otherBotView) {
        _otherBotView = [[UIView alloc] initWithFrame:CGRectMake(30, (DMDeviceWidth - 24) * image.size.height / image.size.width - 10, DMDeviceWidth - 60, 175 + 20)];
        _otherBotView.backgroundColor = UIColorFromRGB(0xffffff);
        _otherBotView.layer.cornerRadius = 5;
        _otherBotView.layer.masksToBounds = YES;
    }
    return _otherBotView;
}

- (CustomTextField *)customTextField {
    if (!_customTextField) {
        _customTextField = [[CustomTextField alloc] initWithFrame:CGRectMake(14, 30 + SPACE, DMDeviceWidth - 88, 40) PlaceHoldFont:11.f PlaceHoldColor:UIColorFromRGB(0x9a9a9a)];
        _customTextField.backgroundColor = UIColorFromRGB(0xf3f3f3);
        _customTextField.placeholder = @"请输入100整数倍的金额";
        [_customTextField addTarget:self action:@selector(stringLengthChange:) forControlEvents:(UIControlEventEditingChanged)];
        _customTextField.returnKeyType = UIReturnKeyDone;
        _customTextField.delegate = self;
    }
    return _customTextField;
}

- (UILabel *)openLabel {
    if (!_openLabel) {
        _openLabel = [UILabel createLabelFrame:CGRectMake(14, 76 + SPACE + 2, LJQ_VIEW_Width(self.otherBotView) / 2 + 50 , 12) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _openLabel.font = FONT_Light(11.f);
        _openLabel.text = @"开放时间：2016.6.28 9:00";
    }
    return _openLabel;
}

- (UILabel *)closeLabel {
    if (!_closeLabel) {
        _closeLabel = [UILabel createLabelFrame:CGRectMake(14, 76 + SPACE + 2 + 18, LJQ_VIEW_Width(self.otherBotView) / 2 + 50 , 12) labelColor:UIColorFromRGB(0x9a9a9a) textAlignment:(NSTextAlignmentLeft) textFont:11.f];
        _closeLabel.font = FONT_Light(11.f);
        _closeLabel.text = @"结束时间：2016.6.28 18:00";
    }
    return  _closeLabel;
}

- (UILabel *)warnLabel{
    if (!_warnLabel) {
        self.warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 76 + SPACE + 2 + 18 + SPACE + 10, LJQ_VIEW_Width(self.otherBotView)-28 , 35)];
        _warnLabel.numberOfLines = 0;
        _warnLabel.text = @"8月14号正式开启小豆机器人服务，请拨打预约电话400-179-1818提前预约";
        _warnLabel.font = FONT_Light(11.f);
        _warnLabel.textColor = MainRed;
    }
    return _warnLabel;
}



- (UIButton *)joinButton {
    UIImage *image = [UIImage imageNamed:@"robtNotStart"];
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_joinButton setFrame:CGRectMake((DMDeviceWidth - 60) / 2 - image.size.width / 2, 100 + 35, image.size.width, image.size.height)];
        [_joinButton setImage:image forState:(UIControlStateNormal)];
        [_joinButton addTarget:self action:@selector(immediatelyJoin:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _joinButton;
}

- (UIButton *)serviceButton {
    if (!_serviceButton) {
        _serviceButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_serviceButton setFrame:CGRectMake((DMDeviceWidth - 24) - 80, 0, 70, 30)];
        [_serviceButton setTitle:@"往期服务>" forState:(UIControlStateNormal)];
        _serviceButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _serviceButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_serviceButton setTitleEdgeInsets:UIEdgeInsetsMake(13, 0, 0, 0)];
        [_serviceButton setTitleColor:UIColorFromRGB(0x41526f) forState:(UIControlStateNormal)];
        [_serviceButton addTarget:self action:@selector(lookPastService) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _serviceButton;
}


@end
