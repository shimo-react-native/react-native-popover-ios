//
//  RNPopoverHostView.m
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/10.
//  Copyright © 2017年 shimo. All rights reserved.
//

#import "RNPopoverHostView.h"

#import <React/RCTAssert.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import <React/RCTShadowView.h>
#import <React/RCTTouchHandler.h>

#import "RNPopoverHostViewController.h"

@interface RNPopoverHostView ()

@property (nonatomic, strong) RNPopoverHostViewController *popoverHostViewController;

@property (nonatomic, copy) RCTPromiseResolveBlock dismissResolve;
@property (nonatomic, copy) RCTPromiseRejectBlock dismissReject;
@property (nonatomic, assign) BOOL presented;

@end

@implementation RNPopoverHostView {
    __weak RCTBridge *_bridge;
    
    RCTTouchHandler *_touchHandler;
    UIView *_contentView;
}

RCT_NOT_IMPLEMENTED(-(instancetype)initWithFrame
                    : (CGRect)frame)
RCT_NOT_IMPLEMENTED(-(instancetype)initWithCoder
                    : coder)

#pragma mark - React

- (instancetype _Nonnull)initWithBridge:(RCTBridge *_Nullable)bridge {
    if ((self = [super initWithFrame:CGRectZero])) {
        _bridge = bridge;
        _presented = NO;
        _animated = YES;
        _cancelable = YES;
        _popoverBackgroundColor = [UIColor whiteColor];
        _sourceView = NSIntegerMax;
        _sourceRect = CGRectNull;
        _permittedArrowDirections = @[@(0), @(1), @(2), @(3)];
        _preferredContentSize = CGSizeZero;
        _popoverHostViewController = [[RNPopoverHostViewController alloc] init];
        _popoverHostViewController.popoverPresentationController.delegate = self;
        _touchHandler = [[RCTTouchHandler alloc] initWithBridge:bridge];
    }
    return self;
}

- (void)insertReactSubview:(UIView *)subview atIndex:(NSInteger)atIndex {
    RCTAssert(_contentView == nil, @"Modal view can only have one subview");
    
    [super insertReactSubview:subview atIndex:atIndex];
    
    [_touchHandler attachToView:subview];
    subview.frame = _popoverHostViewController.view.bounds;
    subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_popoverHostViewController.view insertSubview:subview atIndex:0];
    _contentView = subview;
}

- (void)removeReactSubview:(UIView *)subview {
    RCTAssert(subview == _contentView, @"Cannot remove view other than modal view");
    [super removeReactSubview:subview];
    
    [_touchHandler detachFromView:subview];
    _contentView = nil;
}

- (void)didUpdateReactSubviews {
    // Do nothing, as subview (singular) is managed by `insertReactSubview:atIndex:`
}

- (void)didMoveToWindow {
    [super didMoveToWindow];

    if (!_presented && self.window) {
        RCTAssert(self.reactViewController, @"Can't present popover view controller without a presenting view controller");

        _popoverHostViewController.view.backgroundColor = _popoverBackgroundColor;
        if (_sourceView == NSIntegerMax) {
            NSLog(@"sourceView must be set");
            return;
        }
        UIView *sourceView = [_bridge.uiManager viewForReactTag:@(_sourceView)];
        if (!sourceView) {
            NSLog(@"sourceView is invalid");
            return;
        }
        _presented = YES;
        [self updateContentSize];
        _popoverHostViewController.popoverPresentationController.sourceView = sourceView;
        _popoverHostViewController.popoverPresentationController.sourceRect = CGRectEqualToRect(_sourceRect, CGRectNull) ? sourceView.frame : _sourceRect;
        _popoverHostViewController.popoverPresentationController.backgroundColor = _popoverBackgroundColor;
        _popoverHostViewController.popoverPresentationController.permittedArrowDirections = [self getPermittedArrowDirections];
        if (!CGSizeEqualToSize(CGSizeZero, _preferredContentSize)) {
            _popoverHostViewController.preferredContentSize = _preferredContentSize;
        }
        
        [_delegate presentPopoverHostView:self withViewController:_popoverHostViewController animated:_animated];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if (_presented && !self.superview) {
        [self dismissViewController];
    }
}

#pragma mark - RCTInvalidating

- (void)invalidate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewController];
    });
}

#pragma mark - Public

- (void)dismissViewController {
    if (_presented) {
        [_delegate dismissPopoverHostView:self withViewController:_popoverHostViewController animated:_animated];
        _presented = NO;
    }
}

#pragma mark - UIPopoverPresentationControllerDelegate

// Called on the delegate when the user has taken action to dismiss the popover. This is not called when the popover is dimissed programatically.
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    _presented = NO;
    if (_onHide) {
        _onHide(nil);
    }
}

- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return _cancelable;
}

#pragma mark - Private

- (UIPopoverArrowDirection)getPermittedArrowDirections {
    UIPopoverArrowDirection permittedArrowDirections = 0;
    for (NSNumber *direction in _permittedArrowDirections) {
        if ([direction integerValue] == 0) {
            permittedArrowDirections |= UIPopoverArrowDirectionUp;
        } else if ([direction integerValue] == 1) {
            permittedArrowDirections |= UIPopoverArrowDirectionDown;
        } else if ([direction integerValue] == 2) {
            permittedArrowDirections |= UIPopoverArrowDirectionLeft;
        } else if ([direction integerValue] == 3) {
            permittedArrowDirections |= UIPopoverArrowDirectionRight;
        }
    }
    return permittedArrowDirections;
}

- (void)updateContentSize {
    dispatch_sync(RCTGetUIManagerQueue(), ^{
        RCTShadowView *shadowView = [_bridge.uiManager shadowViewForReactTag:_contentView.reactTag];
        if (shadowView
            && !CGSizeEqualToSize(_preferredContentSize, CGSizeZero)
            && !CGSizeEqualToSize(shadowView.size, _preferredContentSize)) {
            shadowView.size = _preferredContentSize;
            [_bridge.uiManager setNeedsLayout];
        }
    });
}

#pragma mark - Setter

- (void)setPreferredContentSize:(CGSize)preferredContentSize {
    if (CGSizeEqualToSize(_preferredContentSize, preferredContentSize)) {
        return;
    }
    _preferredContentSize = preferredContentSize;
    [self updateContentSize];
}

@end
