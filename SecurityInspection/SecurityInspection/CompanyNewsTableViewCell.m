//
//  CompanyNewsTableViewCell.m
//  SecurityInspection
//
//  Created by cs on 15/4/22.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "CompanyNewsTableViewCell.h"

@implementation CompanyNewsTableViewCell

- (void)awakeFromNib {
//    [self addSubview:self.newsTitle];
    UIImageView * image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    image.image = [UIImage imageNamed:@"new"];
    [self.is_New_point addSubview:image];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (UILabel *)newsTitle{
//    if (!_newsTitle) {
//        _newsTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, 40, 15)];
//        _newsTitle .textAlignment = NSTextAlignmentCenter;
//        _newsTitle.font = [UIFont systemFontOfSize:9.0];
//    }
//    return _newsTitle;
//}
- (void)isNeedShowNew:(NSString *)time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * editTime = [dateFormatter dateFromString:time];
    NSTimeInterval timeBetween = [[NSDate date] timeIntervalSinceDate:editTime];
    //    NSLog(@"%f",timeBetween);
    if (_isreaded) {
        _is_New_point.hidden = YES;
    }else{
        if (timeBetween<2*24*3600) {
            _is_New_point.hidden = NO;
        }else{
            _is_New_point.hidden = YES;
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect); //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 1));
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width-5, 1));
}
@end
