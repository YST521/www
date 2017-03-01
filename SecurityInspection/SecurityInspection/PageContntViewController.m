//
//  PageContntViewController.m
//  SecurityInspection
//
//  Created by cs on 15/5/15.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "PageContntViewController.h"
#import "UIImageView+WebCache.h"
@interface PageContntViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImageView *tmpImageView;
@end

@implementation PageContntViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = ThemeColor;
    NSString *imgUrl = self.dataSource;
    NSString *imageName = [self.dataSource lastPathComponent];
    NSString *imgPath = [DOCUMENT_FOLDER_PATH stringByAppendingPathComponent:imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imgPath]) {
        self.imageView.image = [UIImage imageWithContentsOfFile:imgPath];
    }else{
        UIImage * image = [UIImage imageNamed:imageName];
        self.imageView.image = image;
        NSData *data = UIImageJPEGRepresentation(image, 1.f);
        [data writeToFile:imgPath atomically:YES];
    }
    
    self.tmpImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    [self.tmpImageView setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, 1.f);
            [data writeToFile:imgPath atomically:YES];
            //Added By daniel
            [PublicFunction addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:imgPath]];
        }
    }];
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
