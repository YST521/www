//
//  GuideView.h
//  SecurityInspection
//
//  Created by logic on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *guideImageScorllView;
@property (nonatomic, strong) UIButton *startButton;
@end
