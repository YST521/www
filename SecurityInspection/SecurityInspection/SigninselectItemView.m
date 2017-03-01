//
//  SigninselectItemView.m
//  SecurityInspection
//
//  Created by cs on 15/9/8.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "SigninselectItemView.h"
#import "UIViewController+MaryPopin.h"
#import "RMPickerViewController.h"
#import "staffModel.h"
//#import "Content.h"
@interface SigninselectItemView ()<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    int btntag;
    int yezhuselectitem;
    NSString * yezhuid;
    NSString * xiangmuid;
    NSString * banciid;
    NSString * starttime;
    NSString * endtime;
    ProjectArray * proJect;
}
@property (weak, nonatomic) IBOutlet UITextField *yezhuField;
@property (weak, nonatomic) IBOutlet UITextField *xiangmuField;
@property (weak, nonatomic) IBOutlet UITextField *banciField;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (retain, nonatomic) UIPopoverController *pczPopoverController;
@end

@implementation SigninselectItemView

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.layer.bounds
    self.view.layer.cornerRadius = 8;
    self.view.layer.masksToBounds = YES;
    yezhuid = [UserDefaults objectForKey:@"yezhu_id"];
    xiangmuid = [UserDefaults objectForKey:@"project_id"];
    banciid = [UserDefaults objectForKey:@"banci_id"];
    BOOL isyezhuexist =NO;
    BOOL isxiangmuexist =NO;
    BOOL isbanciexist =NO;
    _oinfo=[ProjectInfoModel sharedInstance].owerinfo.content;
    for (int i=0; i<_oinfo.count; i++) {
        ownerContent * con= _oinfo[i];
        if ([con.contentIdentifier isEqualToString:yezhuid]) {
            yezhuselectitem = i;
            for (ProjectArray *pro in con.projectArray) {
                if ([pro.projectId isEqualToString:xiangmuid]) {
                    proJect = pro;
                    isxiangmuexist = YES;
                    break;
                }
            }
            for (BanciArray *ban in con.banciArray) {
                if ([ban.banciId isEqualToString:banciid]) {
                    starttime = ban.startTime;
                    endtime = ban.endTime;
//                    [UserDefaults setObject:ban.startTime forKey:@"start_time"];
//                    [UserDefaults setObject:ban.endTime forKey:@"end_time"];
                    isbanciexist = YES;
                    break;
                }
            }
            isyezhuexist = YES;
            break;
        }
    }
    if (isyezhuexist) {
        _yezhu = [UserDefaults objectForKey:@"yezhu_name"];
        _yezhuField.text = _yezhu;
    }else{
        yezhuid = nil;
    }
    if (isxiangmuexist) {
        _xiangmu = [UserDefaults objectForKey:@"project_name"];
        _xiangmuField.text = _xiangmu;
    }else{
        xiangmuid = nil;
    }
    if (isbanciexist) {
        _banci = [UserDefaults objectForKey:@"banci_name"];
        _banciField.text = _banci;
    }else{
        banciid = nil;
    }
    [self setTitleWithTitle1:_msg andtitle2:_time];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTitleWithTitle1:(NSString *)tit1 andtitle2:(NSString *)tit2{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tit1];
    NSRange Range1 = [[str string] rangeOfString:tit2 options:NSCaseInsensitiveSearch];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:Range1];
    //    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:Range1];
    self.messagelabel.attributedText = str;
}

- (void)showselectItemZonePopover:(UIButton *)sender withItems:(NSArray *)theItems andProvinceCityZoneTag:(int)tag
{
    NSArray * arr = [NSArray arrayWithObjects:@"选择项目",@"选择岗位",@"选择班次", nil];
    NSString * title = arr[tag-2000];
    RMAction *selectAction = [RMAction actionWithTitle:@"选择" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[picker numberOfComponents] ; i++) {
            [selectedRows addObject:@([picker selectedRowInComponent:i])];
        }
        int proselect;
        int banselect;
        ownerContent * comtent;
        BanciArray * ban;
        switch (btntag) {
            case 2000:
                yezhuselectitem = [selectedRows[0] intValue];
                comtent = _oinfo[yezhuselectitem];
                _yezhu=comtent.yezhuName;
                yezhuid=comtent.contentIdentifier;
                _yezhuField.text = _yezhu;
                break;
            case 2001:
                proselect = [selectedRows[0] intValue];
                comtent = _oinfo[yezhuselectitem];
                proJect = comtent.projectArray[proselect];
                _xiangmu = proJect.projectName;
                xiangmuid = proJect.projectId;
                _xiangmuField.text = _xiangmu;
                break;
            case 2002:
                banselect = [selectedRows[0] intValue];
                comtent = _oinfo[yezhuselectitem];
                ban=comtent.banciArray[banselect];
                _banci = ban.banciName;
                starttime = ban.startTime;
                endtime = ban.endTime;
                banciid = ban.banciId;
                _banciField.text = _banci;
                break;
            default:
                break;
        }
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
//        NSLog(@"Row selection was canceled");
    }];
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleDefault];
    pickerController.title = title;
//    pickerController.message = @"This is a test message.\nPlease choose a row and press 'Select' or 'Cancel'.";
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    pickerController.disableBouncingEffects = YES;
    pickerController.disableMotionEffects = NO;
    pickerController.disableBlurEffects = YES;
    //Now just present the picker view controller using the standard iOS presentation method
    [self presentViewController:pickerController animated:YES completion:nil];
}


- (IBAction)yezhuBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.tag = 2000;
    btntag = 2000;
    [self showselectItemZonePopover:btn withItems:nil andProvinceCityZoneTag:(int)btn.tag];
}
- (IBAction)xiangmuBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.tag = 2001;
    btntag = 2001;
    if (_yezhu) {
        [self showselectItemZonePopover:btn withItems:nil andProvinceCityZoneTag:(int)btn.tag];
    }else{
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置项目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}
- (IBAction)banciBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.tag = 2002;
    btntag = 2002;
    if (_yezhu) {
        [self showselectItemZonePopover:btn withItems:nil andProvinceCityZoneTag:(int)btn.tag];
    }else{
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先设置项目" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)sure:(id)sender {
    if (yezhuid && xiangmuid && banciid) {
        [UserDefaults setObject:yezhuid forKey:@"yezhu_id"];
        [UserDefaults setObject:xiangmuid forKey:@"project_id"];
        [UserDefaults setObject:banciid forKey:@"banci_id"];
        [UserDefaults setObject:_yezhu forKey:@"yezhu_name"];
        [UserDefaults setObject:_xiangmu forKey:@"project_name"];
        [UserDefaults setObject:_banci forKey:@"banci_name"];
        [UserDefaults setObject:starttime forKey:@"start_time"];
        [UserDefaults setObject:endtime forKey:@"end_time"];
//        [staffModel sharedInstance].banci_type = ban.banci_type;
        [_delegate goonsignin:_type withProject:proJect];
        [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
            
        }];
    }else{
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请检查设置是否完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (IBAction)cancel:(id)sender {
    [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
//        NSLog(@"Popin dismissed !");
    }];
}

#pragma mark - RMPickerViewController Delegates
//- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows {
//    
//    NSLog(@"Successfully selected rows: %@", selectedRows);
//}

//- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
////    NSLog(@"Selection was canceled");
//}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    int num;
    ownerContent * comtent;
    switch (btntag) {
        case 2000:
            num=(int)_oinfo.count;
            break;
        case 2001:
            comtent = _oinfo[yezhuselectitem];
            num=(int)comtent.projectArray.count;
            break;
        case 2002:
            comtent = _oinfo[yezhuselectitem];
            num=(int)comtent.banciArray.count;
            break;
        default:
            break;
    }
    return num;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * name;
    ownerContent * comtent;
    ProjectArray * pro;
    BanciArray * ban;
    switch (btntag) {
        case 2000:
            comtent = _oinfo[row];
            name=comtent.yezhuName;
            break;
        case 2001:
            comtent = _oinfo[yezhuselectitem];
            pro=comtent.projectArray[row];
            name = pro.projectName;
            break;
        case 2002:
            comtent = _oinfo[yezhuselectitem];
            ban=comtent.banciArray[row];
            name = ban.banciName;
            break;
        default:
            break;
    }
    return name;
}

@end
