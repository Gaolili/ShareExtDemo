//
//  PriceAlertView.h
//  DoubiDemo
//
//  Created by gaolili on 16/7/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blackAtIndex) (id obj);

@interface PriceAlertView : UIView

+(instancetype)shareInstance;
- (void)showAlertWithData:(NSArray *)data block:(blackAtIndex)block;

@end
