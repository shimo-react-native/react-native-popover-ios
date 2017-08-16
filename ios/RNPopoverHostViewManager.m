//
//  RNPopoverHostViewManager.m
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/10.
//  Copyright © 2017年 shimo. All rights reserved.
//

#import "RNPopoverHostViewManager.h"

#import "RNPopoverHostView.h"
#import "RNPopoverHostViewController.h"

#import <React/RCTBridge.h>
#import <React/RCTShadowView.h>
#import <React/RCTUtils.h>

@interface RNPopoverHostViewManager() <RNPopoverHostViewInteractor>

@end

@implementation RNPopoverHostViewManager  {
    NSHashTable *_hostViews;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(animated, BOOL)
RCT_EXPORT_VIEW_PROPERTY(backgroundColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(sourceViewReactTag, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(sourceRect, CGRect)
RCT_EXPORT_VIEW_PROPERTY(permittedArrowDirections, NSArray)
RCT_EXPORT_VIEW_PROPERTY(preferredContentSize, CGSize)
RCT_EXPORT_VIEW_PROPERTY(onShow, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onHide, RCTDirectEventBlock)

- (UIView *)view {
    RNPopoverHostView *view = [[RNPopoverHostView alloc] initWithBridge:self.bridge];
    view.delegate = self;
    if (!_hostViews) {
        _hostViews = [NSHashTable weakObjectsHashTable];
    }
    [_hostViews addObject:view];
    return view;
}

RCT_EXPORT_METHOD(presentPopoverWithOptions:(NSDictionary *)options
                  callback:(RCTResponseSenderBlock)callback)
{
    
}

#pragma mark - RCTInvalidating

- (void)invalidate {
    for (RNPopoverHostView *hostView in _hostViews) {
        [hostView invalidate];
    }
    [_hostViews removeAllObjects];
}

#pragma mark - RNPopoverHostViewInteractor

- (void)presentPopoverHostView:(RNPopoverHostView *)popoverHostView withViewController:(RNPopoverHostViewController *)viewController animated:(BOOL)animated {
    dispatch_block_t completionBlock = ^{
        if (popoverHostView.onShow) {
            popoverHostView.onShow(nil);
        }
    };
    
    [popoverHostView.reactViewController presentViewController:viewController animated:animated completion:completionBlock];
}

- (void)dismissPopoverHostView:(RNPopoverHostView *)popoverHostView withViewController:(RNPopoverHostViewController *)viewController animated:(BOOL)animated {
    dispatch_block_t completionBlock = ^{
        if (popoverHostView.onHide) {
            popoverHostView.onHide(nil);
        }
    };
    
    [viewController dismissViewControllerAnimated:animated completion:completionBlock];
}

@end
