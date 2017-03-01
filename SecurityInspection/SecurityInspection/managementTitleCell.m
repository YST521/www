//
//  managementTitleCell.m
//  SecurityInspection
//
//  Created by cs on 15/4/29.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "managementTitleCell.h"

@implementation managementTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect); //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height, rect.size.width, 1));
}
@end
