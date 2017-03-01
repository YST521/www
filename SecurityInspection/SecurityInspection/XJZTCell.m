//
//  XJZTCell.m
//  SecurityInspection
//
//  Created by cs on 15/5/4.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "XJZTCell.h"

@implementation XJZTCell

- (void)awakeFromNib {
    // Initialization code
    self.XJZTSwitch.backgroundColor = [UIColor clearColor];
    self.XJZTSwitch.tintColor = [UIColor orangeColor];
    self.XJZTSwitch.onText = @"正常";
    self.XJZTSwitch.offText = @"不正常";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
