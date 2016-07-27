//
//  PriceAlertView.m
//  DoubiDemo
//
//  Created by gaolili on 16/7/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PriceAlertView.h"
#import "PriceCell.h"

#define RowH 100
#define FootH 45

#define ScreenH CGRectGetHeight([UIScreen mainScreen].bounds)
#define ScreenW CGRectGetWidth([[UIScreen mainScreen] bounds])

@interface PriceAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIButton * grayBtn;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic,strong)NSArray * dataArray;
@property (nonatomic,copy)blackAtIndex clickBlock;

@end

@implementation PriceAlertView

+(instancetype)shareInstance{
    static PriceAlertView * _shareInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[PriceAlertView alloc]init];
    });
    return _shareInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        _dataArray = [NSArray array];
        
        _grayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _grayBtn.backgroundColor = [UIColor colorWithWhite:0.25 alpha:1];
        [_grayBtn addTarget:self action:@selector(hideAlertView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_grayBtn];
        
        _tableView = [[UITableView alloc] init];
 
        UINib * nib = [UINib nibWithNibName:@"PriceCell" bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:NSStringFromClass([PriceCell class])];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.scrollEnabled = NO;
        _tableView.tableFooterView = [self tableViewFootView];
        [_grayBtn addSubview:_tableView];
        
    }
    return self;
}


#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RowH;
}
- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PriceCell * cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PriceCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.priceLabel.text = [NSString stringWithFormat:@"%@元",_dataArray[indexPath.row]];
    __weak PriceAlertView * weakSelf = self;
    cell.block =^(){
        if (_clickBlock) {
            _clickBlock(_dataArray[indexPath.row]);
        }
          [weakSelf hideAlertView];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (UIView *)tableViewFootView{
    UILabel * close = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, FootH)];
    close.backgroundColor = [UIColor redColor];
    close.userInteractionEnabled = YES;
    close.text = @"关闭";
    close.textAlignment = NSTextAlignmentCenter;
    close.textColor = [UIColor whiteColor];
    close.font= [UIFont systemFontOfSize:14];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAlertView)];
    [close addGestureRecognizer:tap];
    return close;
}

#pragma mark -

-(UIWindow *)getTopLevelWindow{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    for (UIWindow *_window in [[UIApplication sharedApplication] windows]) {
        if(window==nil){
            window=_window;
        }
        if(_window.windowLevel>window.windowLevel){
            window=_window;
        }
    }
    return window;
}

- (void)showAlertWithData:(NSArray *)data block:(blackAtIndex)block{
    _dataArray = data;
    _clickBlock = block;
    [_tableView reloadData];
    [self showInSuperView:[self getTopLevelWindow]];

}

- (void) showInSuperView:(UIView *) view
{
    self.frame = [[UIScreen mainScreen] bounds];
    if (!view) {
        UIView *presentView = [UIApplication sharedApplication].keyWindow;
        [presentView addSubview:self];
    } else {
        [view addSubview:self];
    }
    
    _grayBtn.frame = CGRectMake(0, ScreenH, ScreenW, 0.0);
    _tableView.frame = _grayBtn.bounds;
    NSInteger tableHeight = _dataArray.count * RowH + FootH ;
    
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.23 animations:^{
        _grayBtn.frame = CGRectMake(0, 0, ScreenW, ScreenH);;
        _tableView.frame = CGRectMake(0, ScreenH - tableHeight , ScreenW, tableHeight);
    }];
}


- (void)hideAlertView{
    [UIView animateWithDuration:0.23 animations:^{
        _grayBtn.frame = CGRectMake(0, ScreenH, ScreenW, 0.0);
        _tableView.frame = _grayBtn.bounds;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1;
        [self removeFromSuperview];
    }];

}

@end
