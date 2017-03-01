//
//  SigninselectItemView.h
//  SecurityInspection
//
//  Created by cs on 15/9/8.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectInfoModel.h"
@protocol SigninselectItemDelegate
-(void)goonsignin:(int)type withProject:(ProjectArray *)project;
@end
@interface SigninselectItemView : UIViewController{
//    id<SigninselectItemDelegate> deleage;
}
@property (nonatomic,copy)NSString * msg;
@property (nonatomic,copy)NSString * time;
@property (nonatomic,strong)NSArray * oinfo;
@property (nonatomic,strong)NSArray * pinfo;
@property (nonatomic,strong)NSArray * binfo;
@property (nonatomic,copy)NSString * yezhu;
@property (nonatomic,copy)NSString * xiangmu;
@property (nonatomic,copy)NSString * banci;
@property (nonatomic,assign)int type;
@property(assign,nonatomic)id<SigninselectItemDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *messagelabel;
- (void)setTitleWithTitle1:(NSString *)tit1 andtitle2:(NSString *)tit2;
@end
