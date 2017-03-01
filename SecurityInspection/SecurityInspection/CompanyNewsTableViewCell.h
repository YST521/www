//
//  CompanyNewsTableViewCell.h
//  SecurityInspection
//
//  Created by cs on 15/4/22.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;
//@property (nonatomic,strong)UILabel * newsTitle;
@property (weak, nonatomic) IBOutlet UIView *is_New_point;
@property (nonatomic,assign)BOOL isreaded;
- (void)isNeedShowNew:(NSString *)time;
@end
