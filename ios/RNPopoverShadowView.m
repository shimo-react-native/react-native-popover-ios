//
//  RNPopoverShadowView.m
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/15.
//  Copyright © 2017年 shimo.im. All rights reserved.
//

#import "RNPopoverShadowView.h"
#import <React/RCTUtils.h>

@implementation RNPopoverShadowView

- (void)insertReactSubview:(id<RCTComponent>)subview atIndex:(NSInteger)atIndex
{
    [super insertReactSubview:subview atIndex:atIndex];
//    if ([subview isKindOfClass:[RCTShadowView class]]) {
//        ((RCTShadowView *)subview).size = RCTScreenSize();
//    }
}

@end
