//
//  PlanViewController.h
//  SecurityInspection
//
//  Created by logic on 15/4/23.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface PlanViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
}
@property (nonatomic,strong)NSMutableArray *allDataAry;
@property (nonatomic,strong)NSString *planId;
@property (nonatomic,strong)NSString *banciId;
@property (nonatomic,strong)NSString *planStartTime;
@property (nonatomic,strong)NSMutableArray *dataAry;
@property (nonatomic,strong) UIImageView * line;
@property (nonatomic,strong)NSMutableArray *checkPointIds;
@property (nonatomic,strong)UITableView *tableView;

@end
