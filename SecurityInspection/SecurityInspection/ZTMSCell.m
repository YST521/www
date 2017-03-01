//
//  ZTMSCell.m
//  SecurityInspection
//
//  Created by cs on 15/5/4.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "ZTMSCell.h"

@implementation ZTMSCell

- (void)awakeFromNib {
    // Initialization code
    self.label.enabled = NO;
    self.label.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
