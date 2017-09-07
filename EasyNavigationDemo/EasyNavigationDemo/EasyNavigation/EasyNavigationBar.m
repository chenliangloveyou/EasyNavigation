//
//  EasyNavigationBar.m
//  EasyNavigationDemo
//
//  Created by nf on 2017/9/7.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "EasyNavigationBar.h"

#import "EasyUtils.h"

static CGFloat const kSpaceToCoverStatusBars = 20.0f;


@interface EasyNavigationBar()

@property (nonatomic, strong) UIView *statusView;


@end

@implementation EasyNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.statusView = [[UIView alloc] init];
        self.statusView.backgroundColor = [UIColor yellowColor] ;
        [self addSubview:self.statusView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [[EasyUtils createImageWithColor:[UIColor redColor]] drawInRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.statusView) {
        self.statusView.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), kSpaceToCoverStatusBars);
    }
}
@end
