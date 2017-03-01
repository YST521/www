//
//  XJXMCell.h
//  SecurityInspection
//
//  Created by cs on 15/5/4.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarqueeLabel.h"
@interface XJXMCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MarqueeLabel *itemTitle;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
