//
//  PriceCell.h
//  DoubiDemo
//
//  Created by gaolili on 16/7/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickUseBlock)();
@interface PriceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UIButton *useBtn;
@property (strong, nonatomic) ClickUseBlock block;
@end
