//
//  RNPopoverHostViewController.m
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/10.
//  Copyright © 2017年 shimo.im. All rights reserved.
//

#import "RNPopoverHostViewController.h"

@interface RNPopoverHostViewController ()

@end

@implementation RNPopoverHostViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationPopover;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [_popoverHostDelegate didContentFrameUpdated:self];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [_popoverHostDelegate didContentFrameUpdated:self];
}

#pragma mark - Getter

- (CGRect)contentFrame {
    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
    CGRect frame = self.view.bounds;
    return CGRectMake(CGRectGetMinX(frame) + safeAreaInsets.left, CGRectGetMinY(frame) + safeAreaInsets.top, CGRectGetWidth(frame) - safeAreaInsets.left - safeAreaInsets.right, CGRectGetHeight(frame) - safeAreaInsets.top - safeAreaInsets.bottom);
}

@end
