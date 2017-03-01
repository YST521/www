//
//  noticeTableViewCell.h
//  SecurityInspection
//
//  Created by cs on 15/4/29.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface noticeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIView *is_New_point;
@property (nonatomic,assign)BOOL isreaded;
- (void)isNeedShowNew:(NSString *)time;
@end
