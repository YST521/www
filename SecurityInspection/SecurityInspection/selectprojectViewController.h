//
//  selectprojectViewController.h
//  SecurityInspection
//
//  Created by cs on 15/9/11.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectInfoModel.h"
@protocol selectprojectItemDelegate
-(void)gotogetprojectinfo;
@end
@interface selectprojectViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *xiangmuField;
@property (weak, nonatomic) IBOutlet UIButton *xiangmuBtn;
@property (nonatomic,strong)NSArray * oinfo;
@property (nonatomic,strong)NSArray * pinfo;
@property (nonatomic,copy)NSString * xiangmu;
@property(assign,nonatomic)id<selectprojectItemDelegate> delegate;
@end