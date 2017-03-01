//
//  PatrolConditionViewController.h
//  SecurityInspection
//
//  Created by logic on 15/4/23.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatrolConditionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UITextField *describeStatusTet;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *projectId;
@property (nonatomic,strong)NSString *planId;
@property (nonatomic,strong)NSString *banci_id;
@property (nonatomic,strong)NSString *pointId;
@property (nonatomic,strong)NSString *check_items;
@property (nonatomic,strong)NSString *stasus;
@property (nonatomic,strong)NSString *note;
@property (nonatomic,strong)NSString *needImage;
@property (nonatomic,strong)NSString *image;
@property (nonatomic,strong)NSString *is_start;
@property (nonatomic,strong)NSString *checkTime;
@property (nonatomic,strong)NSString *planStartTime;
@property (nonatomic,strong)NSMutableArray *allDataAry;
@property (nonatomic,strong)NSMutableArray *dataAry;

@end
