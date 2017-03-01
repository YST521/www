//
//  PatrolConditionViewController.m
//  SecurityInspection
//
//  Created by logic on 15/4/23.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "PatrolConditionViewController.h"
#import "MBProgressHUD.h"
#import "PlanViewController.h"
#import "ZJSwitch.h"
#import "XJTitleCell.h"
#import "XJXMCell.h"
#import "XJZTCell.h"
#import "PZSCCell.h"
#import "PZSCImageCell.h"
#import "ZTMSCell.h"
#import "CheckingStatusModel.h"
#define ORIGINAL_MAX_WIDTH 200.0f
@interface PatrolConditionViewController ()
@property (nonatomic,strong)UILabel * MSlabel;
@property (nonatomic,strong)NSMutableArray *itemsSelect;
@property (nonatomic,assign)BOOL ison;
@property (nonatomic,strong)UIImage * photoImage;
@property (nonatomic,strong)NSString * ztmsTxt;

@end

@implementation PatrolConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
//        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
//    }
//    NSLog(@"%@",self.dataAry);
    _userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    _projectId = [[NSUserDefaults standardUserDefaults] objectForKey:@"project_id"];
    _itemsSelect = [NSMutableArray array];
    _ison = NO;
    for (NSDictionary * dict in _dataAry) {
        [_itemsSelect addObject:[NSNumber numberWithBool:NO]];
    }
    self.title = @"巡检情况";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NavBar.hidden = NO;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[PublicFunction skinFromImageName:@"arrow_left.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonClick)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [CheckingStatusModel sharedInstance].user_id = nil;
    [CheckingStatusModel sharedInstance].project_id = nil;
    [CheckingStatusModel sharedInstance].plan_id = nil;
    [CheckingStatusModel sharedInstance].banci_id = nil;
    [CheckingStatusModel sharedInstance].point_id = nil;
    [CheckingStatusModel sharedInstance].check_items = @"";
    [CheckingStatusModel sharedInstance].status = nil;
    [CheckingStatusModel sharedInstance].note = nil;
    [CheckingStatusModel sharedInstance].image = nil;
    [CheckingStatusModel sharedInstance].is_start = nil;
    [CheckingStatusModel sharedInstance].check_time = nil;
    [CheckingStatusModel sharedInstance].plan_start_time = nil;
}

- (void)leftButtonClick
{
    int index=[[self.navigationController viewControllers]indexOfObject:self];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataAry.count == 0) {
        return 3;
    }else{
        return 4;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataAry.count == 0) {
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            if (_photoImage) {
                return 2;
            }else{
                return 1;
            }
        }else {
            return 2;
        }
    }else{
        if (section == 0) {
            return self.dataAry.count+1;
        }else if (section == 1) {
            return 1;
        }else if (section == 2) {
            if (_photoImage) {
                return 2;
            }else{
                return 1;
            }
        }else {
            return 2;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count == 0) {
        if (indexPath.section == 1 && indexPath.row != 0) {
            return 250;
        }
        if (indexPath.section == 2 && indexPath.row != 0) {
            return 120;
        }
        else {
            return 44;
        }
    }else{
        if (indexPath.section == 0 && indexPath.row != 0) {
            return 40;
        }
        if (indexPath.section == 2 && indexPath.row != 0) {
            return 250;
        }
        if (indexPath.section == 3 && indexPath.row != 0) {
            return 120;
        }
        else {
            return 44;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count == 0) {
        if (indexPath.section ==0 && indexPath.row == 0){
            static NSString *CellTableIdentifier = @"XJZT";
            XJZTCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"XJZTCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.XJZTSwitch setOn:_ison animated:NO];
            [cell.XJZTSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }else if (indexPath.section ==1 && indexPath.row == 0){
            static NSString *CellTableIdentifier = @"PZSC";
            PZSCCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"PZSCCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.takePhotoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (indexPath.section ==1 && indexPath.row != 0){
            static NSString *CellTableIdentifier = @"PZSCImage";
            PZSCImageCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                   CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"PZSCImageCell" owner:self options:nil]lastObject];
            }
            cell.photo.image = _photoImage;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section ==2 && indexPath.row == 0){
            static NSString *CellTableIdentifier = @"XJTitle";
            XJTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"XJTitleCell" owner:self options:nil]lastObject];
            }
            cell.title.text=@"状态描述";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *CellTableIdentifier = @"ZTMS";
            ZTMSCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ZTMSCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.MStext.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            cell.MStext.delegate = self;
            _MSlabel=cell.label;
            if (_ztmsTxt.length != 0) {
                cell.MStext.text =_ztmsTxt;
                _MSlabel.text = @"";
            }
            return cell;
        }
    }else{
        if (indexPath.section ==0 && indexPath.row == 0) {
            static NSString *CellTableIdentifier = @"XJTitle";
            XJTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"XJTitleCell" owner:self options:nil]lastObject];
            }
            cell.title.text=@"巡检项目";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section ==0 && indexPath.row != 0){
            static NSString *CellTableIdentifier = @"XJXM";
            XJXMCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"XJXMCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.itemTitle.text = self.dataAry[indexPath.row-1][@"item_content"];
//            cell.itemTitle.text = @"盛大富翁企鹅夫妻未插入去维持体温入场日期为他去问题问题双方都撒地方嘎斯的嘎斯是否VGA嗦嘎是";
            cell.itemTitle.scrollDuration = 8.0;
            cell.itemTitle.fadeLength = 10.0f;
            if ([self.itemsSelect[indexPath.row-1] boolValue]) {
                cell.image.image = [UIImage imageNamed:@"checkbox_on"];
            }else{
                cell.image.image = [UIImage imageNamed:@"checkbox_off"];
            }
            return cell;
        }else if (indexPath.section ==1 && indexPath.row == 0){
            static NSString *CellTableIdentifier = @"XJZT";
            XJZTCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"XJZTCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.XJZTSwitch setOn:_ison animated:NO];
            [cell.XJZTSwitch addTarget:self action:@selector(handleSwitchEvent:) forControlEvents:UIControlEventValueChanged];
            return cell;
        }else if (indexPath.section ==2 && indexPath.row == 0){
            static NSString *CellTableIdentifier = @"PZSC";
            PZSCCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"PZSCCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.takePhotoBtn addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else if (indexPath.section ==2 && indexPath.row != 0){
            static NSString *CellTableIdentifier = @"PZSCImage";
            PZSCImageCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                   CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"PZSCImageCell" owner:self options:nil]lastObject];
            }
            cell.photo.image = _photoImage;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section ==3 && indexPath.row == 0){
            static NSString *CellTableIdentifier = @"XJTitle";
            XJTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"XJTitleCell" owner:self options:nil]lastObject];
            }
            cell.title.text=@"状态描述";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *CellTableIdentifier = @"ZTMS";
            ZTMSCell *cell = [tableView dequeueReusableCellWithIdentifier:
                              CellTableIdentifier];
            if (cell == nil) {
                cell=[[[NSBundle mainBundle]loadNibNamed:@"ZTMSCell" owner:self options:nil]lastObject];
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.MStext.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            cell.MStext.delegate = self;
            cell.MStext.returnKeyType = UIReturnKeyDone;
            _MSlabel=cell.label;
            if (_ztmsTxt.length != 0) {
                cell.MStext.text =_ztmsTxt;
                _MSlabel.text = @"";
            }
            return cell;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataAry.count != 0) {
        if (indexPath.section ==0 && indexPath.row != 0) {
            if ([self.itemsSelect[indexPath.row-1] boolValue]) {
                self.itemsSelect[indexPath.row-1] = [NSNumber numberWithBool:NO];
            }else{
                self.itemsSelect[indexPath.row-1] = [NSNumber numberWithBool:YES];
            }
            NSArray *array = [NSArray arrayWithObjects:indexPath,nil];
            [self.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.dataAry.count == 0) {
        if (section == 2) {
            return 60;
        }
        else {
            return 1;
        }
    }else{
        if (section == 3) {
            return 60;
        }
        else {
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.dataAry.count == 0) {
        if (section == 2) {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
            UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 40)];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            submitBtn.backgroundColor = [UIColor redColor];
            [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:submitBtn];
            return footView;
        }
        else {
            return nil;
        }
    }else{
        if (section == 3) {
            UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
            UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 10, ScreenWidth-40, 40)];
            [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
            submitBtn.backgroundColor = [UIColor redColor];
            [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:submitBtn];
            return footView;
        }
        else {
            return nil;
        }
    }
    
}
#pragma mark - imagePickerController
- (void)photoBtnClick:(UIButton *)sender
{
    UIImagePickerController*thePicker=[[UIImagePickerController alloc]init];
    thePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    thePicker.delegate=self;
    [self presentViewController:thePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    NSLog(@"%@",info);
    _photoImage=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if (self.dataAry.count == 0) {
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else{
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if (self.dataAry.count != 0) {
        [self moveView:-190];
    }
    
}
-(void)textViewDidChange:(UITextView *)textView
{
    self.ztmsTxt =  textView.text;
    if (textView.text.length == 0) {
        _MSlabel.text = @"请在这里描述巡检情况。";
    }else{
        _MSlabel.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.dataAry.count != 0) {
        [self moveView:190];
    }
}

-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的X轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

#pragma mark - other
- (void)submitBtnClick:(UIButton *)sender
{
    int num = 0;
    _check_items = @"";
    for (int i = 0; i<_dataAry.count; i++) {
        if ([_itemsSelect[i] boolValue]) {
            NSString * str = _dataAry[i][@"item_id"];
            _check_items =[_check_items stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
            num ++;
        }
    }
    if (num>=1) {
        _check_items = [_check_items substringToIndex:(_check_items.length - 1)];
    }
    [CheckingStatusModel sharedInstance].user_id = _userId;
    [CheckingStatusModel sharedInstance].project_id = _projectId;
    [CheckingStatusModel sharedInstance].plan_id = _planId;
    [CheckingStatusModel sharedInstance].banci_id = _banci_id;
    [CheckingStatusModel sharedInstance].point_id = _pointId;
    [CheckingStatusModel sharedInstance].check_items = _check_items;
    [CheckingStatusModel sharedInstance].status = [NSString stringWithFormat:@"%d",_ison];
    if (_ztmsTxt == nil) {
        _ztmsTxt = @"";
    }
    [CheckingStatusModel sharedInstance].note = _ztmsTxt;
    _photoImage = [self imageByScalingToMaxSize:_photoImage];
    if (_needImage == nil || [_needImage isEqualToString:@"0"]) {
        if (_photoImage) {
            [CheckingStatusModel sharedInstance].image = [PublicFunction imageToBase64String:_photoImage];
        }else{
            [CheckingStatusModel sharedInstance].image = @"";
        }
    }else{
        if (_photoImage) {
            [CheckingStatusModel sharedInstance].image = [PublicFunction imageToBase64String:_photoImage];
        }else{
            UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"需要拍照才能提交" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }
    }
    [CheckingStatusModel sharedInstance].is_start = _is_start;
    NSDate * df = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _checkTime = [dateFormatter stringFromDate:df];
    [CheckingStatusModel sharedInstance].check_time = _checkTime;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:df];
    _planStartTime = [NSString stringWithFormat:@"%@ %@",destDateString,_planStartTime];
    [CheckingStatusModel sharedInstance].plan_start_time =_planStartTime;
    
    if([CheckingStatusModel sharedInstance].image != nil){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Configure for text only and offset down
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"数据加载中";
        hud.margin = 10.f;
        hud.minSize = CGSizeMake(ScreenWidth/2, ScreenHeight/6);
        hud.color = [UIColor grayColor];
        hud.removeFromSuperViewOnHide = YES;
        hud.dimBackground = YES;
        [[CheckingStatusModel sharedInstance] uploadCheckingStatusWithParameters:nil successBlock:^(id responseObject, NSDictionary *userInfo) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = responseObject;
                NSInteger statusCode = [dict[@"result"][@"status"] integerValue];
                if (200 == statusCode) {
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag =4000;
                    [alert show];
                }else{
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:@"未知错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            [hud hide:YES];
        } errorBlock:^(NSError *error) {
            [hud hide:YES];
        }];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==4000) {
//        NSLog(@"%ld",(long)buttonIndex);
        [DefaultNotificationCenter postNotificationName:@"updateCheckPointids" object:_pointId];
        int index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:YES];
    }
}

- (void)handleSwitchEvent:(ZJSwitch *)sender
{
    if (_ison) {
        _ison = NO;
    }else{
        _ison = YES;
    }
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGSize targetSize = CGSizeMake(ScreenWidth*0.3, ScreenHeight*0.3);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContextWithOptions(targetSize,YES,1);
    //UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    //NSLog(@" %f, %f",scaledWidth,scaledHeight);
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end
