//
//  GuideView.m
//  SecurityInspection
//
//  Created by logic on 15/4/24.
//  Copyright (c) 2015年 logicsolutions. All rights reserved.
//

#import "GuideView.h"

#define tagGuideImageViewBase 1000

#define kGuideStartButtonFrame CGRectMake(320+140,380,100,46)

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *aScorllView = [[UIScrollView alloc] initWithFrame:self.bounds];
        aScorllView.delegate = self;
        self.guideImageScorllView = aScorllView;
        [self addSubview:self.guideImageScorllView];
        [self initializeScrollView];
        
    }
    return self;
}

- (void)initializeScrollView
{
    
    for (UIView *subview in self.guideImageScorllView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.guideImageScorllView.pagingEnabled = YES;
    self.guideImageScorllView.showsHorizontalScrollIndicator = NO;
    
    //add image views
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.guideImageScorllView.bounds.size.width, 0, self.guideImageScorllView.bounds.size.width, self.guideImageScorllView.bounds.size.height)];
        imageView.tag = tagGuideImageViewBase + i;
        
        NSString *imageName = nil;

        imageName = @"欢迎页";
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        
        imageView.image = image;
        [self.guideImageScorllView addSubview:imageView];
    }
    
    //add startButton
    if (!self.startButton) {
        self.startButton = [[UIButton alloc] initWithFrame:kGuideStartButtonFrame];
        
//        [self.startButton setBackgroundImage:[UIImage imageNamed:@".png"] forState:UIControlStateNormal];
//        [self.startButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.startButton.backgroundColor = [UIColor orangeColor];
        self.startButton.titleLabel.font = [UIFont systemFontOfSize:24];
        [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.startButton addTarget:self action:@selector(pressButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.startButton setTitle:@"开始使用" forState:UIControlStateNormal];
    [self.guideImageScorllView addSubview:self.startButton];
    
    [self.guideImageScorllView setContentSize:CGSizeMake(self.guideImageScorllView.bounds.size.width*2, self.guideImageScorllView.bounds.size.height)];
}


- (void)pressButton:(UIButton *)sender
{
    if (sender == self.startButton) {
        [self endShowGuide];
    }
    
}

- (void)endShowGuide
{
    CGRect bounds = self.bounds;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:(UIViewAnimationOptionCurveEaseInOut) animations:^{
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
        self.alpha = 0.2f;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.alpha = 1.0f;
        self.bounds = bounds;
        [self removeFromSuperview];
    }];
    
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > scrollView.bounds.size.width*2 + 10) {
        scrollView.scrollEnabled = NO;
        [self endShowGuide];
    }
}


@end
