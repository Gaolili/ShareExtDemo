//
//  PriceCell.m
//  DoubiDemo
//
//  Created by gaolili on 16/7/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PriceCell.h"

@implementation PriceCell
- (IBAction)ClickUserAction:(id)sender {
    if (_block) {
        _block();
    }
}

@end
