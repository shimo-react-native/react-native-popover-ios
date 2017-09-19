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
#import "RNPopoverTargetManager.h"

@interface RNPopoverHostView ()

@property (nonatomic, strong) RNPopoverHostViewController *popoverHostViewController;

@property (nonatomic, copy) RCTPromiseResolveBlock dismissResolve;
@property (nonatomic, copy) RCTPromiseRejectBlock dismissReject;
@property (nonatomic, assign) BOOL presented;

@property (nonatomic, assign) CGRect realSourceRect;
@property (nonatomic, assign) CGSize realPreferredContentSize;

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
        _sourceViewTag = -1;
        _sourceViewGetterTag = -1;
        _sourceViewReactTag = -1;
        _realSourceRect = CGRectNull;
        _permittedArrowDirections = @[@(0), @(1), @(2), @(3)];
        _realPreferredContentSize = CGSizeZero;
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
        
        UIView *sourceView = [self autoGetSourceView];
        if (!sourceView) {
            NSLog(@"sourceView is invalid");
            if (_onHide) {
                _onHide(nil);
            }
            return;
        }
        _presented = YES;
        [self updateContentSize];
        _popoverHostViewController.popoverPresentationController.sourceView = sourceView;
        _popoverHostViewController.popoverPresentationController.sourceRect = CGRectEqualToRect(_realSourceRect, CGRectNull) ? sourceView.bounds : _realSourceRect;
        _popoverHostViewController.popoverPresentationController.backgroundColor = _popoverBackgroundColor;
        _popoverHostViewController.popoverPresentationController.permittedArrowDirections = [self getPermittedArrowDirections];
        if (!CGSizeEqualToSize(CGSizeZero, _realPreferredContentSize)) {
            _popoverHostViewController.preferredContentSize = _realPreferredContentSize;
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
    if (!CGSizeEqualToSize(_realPreferredContentSize, CGSizeZero) &&
        !CGSizeEqualToSize(_popoverHostViewController.preferredContentSize, _realPreferredContentSize)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _popoverHostViewController.preferredContentSize = _realPreferredContentSize;
        });
    }

    dispatch_sync(RCTGetUIManagerQueue(), ^{
        RCTShadowView *shadowView = [_bridge.uiManager shadowViewForReactTag:_contentView.reactTag];
        if (shadowView
            && !CGSizeEqualToSize(_realPreferredContentSize, CGSizeZero)
            && !CGSizeEqualToSize(shadowView.size, _realPreferredContentSize)) {
            shadowView.size = _realPreferredContentSize;
            [_bridge.uiManager setNeedsLayout];
        }
    });
}

- (UIView *)autoGetSourceView {
    UIView *sourceView = nil;
    if (_sourceViewReactTag >= 0) {
        sourceView = [_bridge.uiManager viewForReactTag:@(_sourceViewReactTag)];
    } else if (_sourceViewTag >= 0) {
        sourceView = [[RNPopoverTargetManager getInstance] viewForTag:_sourceViewTag];
    } else if (_sourceViewGetterTag >= 0) {
        sourceView = [[RNPopoverTargetManager getInstance] viewForGetterTag:_sourceViewGetterTag];
    }
    return sourceView;
}

#pragma mark - Setter

- (void)setPreferredContentSize:(NSArray *)preferredContentSize {
    if (preferredContentSize.count != 2 || [_preferredContentSize isEqualToArray:preferredContentSize]) {
        return;
    }
    _preferredContentSize = preferredContentSize;
    _realPreferredContentSize = CGSizeMake([_preferredContentSize[0] floatValue], [_preferredContentSize[1] floatValue]);
    [self updateContentSize];
}

- (void)setSourceRect:(NSArray *)sourceRect {
    if (sourceRect.count != 4 || [_sourceRect isEqualToArray:sourceRect]) {
        return;
    }
    _sourceRect = sourceRect;
    _realSourceRect = CGRectMake([_sourceRect[0] floatValue], [_sourceRect[1] floatValue], [_sourceRect[2] floatValue], [_sourceRect[3] floatValue]);
}

@end
