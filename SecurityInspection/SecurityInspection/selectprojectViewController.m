//
//  selectprojectViewController.m
//  SecurityInspection
//
//  Created by cs on 15/9/11.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "selectprojectViewController.h"
#import "UIViewController+MaryPopin.h"
#import "RMPickerViewController.h"

@interface selectprojectViewController ()<UIActionSheetDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    NSString * yezhuid;
    NSString * xiangmuid;
    NSString * banciid;
    ownerContent * content;
}
@property (retain, nonatomic) UIPopoverController *pczPopoverController;

@end

@implementation selectprojectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8;
    self.view.layer.masksToBounds = YES;
    yezhuid = [UserDefaults objectForKey:@"yezhu_id"];
    xiangmuid = [UserDefaults objectForKey:@"project_id"];
    banciid = [UserDefaults objectForKey:@"banci_id"];
    _xiangmu = [UserDefaults objectForKey:@"project_name"];
    _xiangmuField.text = _xiangmu;
    _oinfo=[ProjectInfoModel sharedInstance].owerinfo.content;
    for (ownerContent * info in _oinfo) {
        if ([info.contentIdentifier isEqualToString:yezhuid]) {
            content = info;
        }
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sure:(id)sender {
    if (xiangmuid) {
        [UserDefaults setObject:xiangmuid forKey:@"project_id"];
        [UserDefaults setObject:_xiangmu forKey:@"project_name"];
        [_delegate gotogetprojectinfo];
        [self.presentingPopinViewController dismissCurrentPopinControllerAnimated:YES completion:^{
            
        }];
    }else{
        UIAlertView*alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请检查设置是否完成" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)showselectItemZonePopover:(UIButton *)sender withItems:(NSArray *)theItems andProvinceCityZoneTag:(int)tag
{
    RMAction *selectAction = [RMAction actionWithTitle:@"选择" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        UIPickerView *picker = ((RMPickerViewController *)controller).picker;
        NSMutableArray *selectedRows = [NSMutableArray array];
        
        for(NSInteger i=0 ; i<[picker numberOfComponents] ; i++) {
            [selectedRows addObject:@([picker selectedRowInComponent:i])];
        }
        int proselect;
        ProjectArray * pro;
        proselect = [selectedRows[0] intValue];
        pro=content.projectArray[proselect];
        _xiangmu = pro.projectName;
        xiangmuid = pro.projectId;
        _xiangmuField.text = _xiangmu;
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        //        NSLog(@"Row selection was canceled");
    }];
    RMPickerViewController *pickerController = [RMPickerViewController actionControllerWithStyle:RMActionControllerStyleDefault];
    pickerController.title = @"选择岗位";
    pickerController.picker.dataSource = self;
    pickerController.picker.delegate = self;
    [pickerController addAction:selectAction];
    [pickerController addAction:cancelAction];
    pickerController.disableBouncingEffects = YES;
    pickerController.disableMotionEffects = NO;
    pickerController.disableBlurEffects = YES;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (IBAction)xiangmuBtn:(id)sender {
    UIButton * btn = (UIButton *)sender;
    btn.tag = 2001;
    [self showselectItemZonePopover:btn withItems:nil andProvinceCityZoneTag:(int)btn.tag];
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
    return content.projectArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * name;
    ProjectArray * pro;
    pro=content.projectArray[row];
    name = pro.projectName;
    return name;
}


@end
