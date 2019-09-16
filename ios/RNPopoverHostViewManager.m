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
#import <React/RCTUIManager.h>
#import <React/RCTShadowView.h>
#import <React/RCTUtils.h>

@interface RNPopoverHostViewManager() <RNPopoverHostViewInteractor>

@property (nonatomic, copy) RCTPromiseResolveBlock dismissResolve;
@property (nonatomic, assign) BOOL userDismiss;
@property (nonatomic, assign) BOOL dismissAnimated;

@end

@implementation RNPopoverHostViewManager  {
    NSHashTable *_hostViews;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(animated, BOOL)
RCT_EXPORT_VIEW_PROPERTY(popoverBackgroundColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(sourceViewReactTag, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(sourceViewTag, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(sourceViewNativeID, NSString)
RCT_EXPORT_VIEW_PROPERTY(sourceViewGetterTag, NSInteger)
RCT_EXPORT_VIEW_PROPERTY(sourceRect, NSArray)
RCT_EXPORT_VIEW_PROPERTY(permittedArrowDirections, NSArray)
RCT_EXPORT_VIEW_PROPERTY(preferredContentSize, NSArray)
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

RCT_REMAP_METHOD(dismiss,
                 dismissWithReactTag:(nonnull NSNumber *)reactTag animated:(BOOL)animated Resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    __weak typeof(self) weakSelf = self;
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        __kindof UIView *view = viewRegistry[reactTag];
        if ([view isKindOfClass:[RNPopoverHostView class]]) {
            RNPopoverHostView *hostView = view;
            if (hostView.presented) {
                weakSelf.userDismiss = YES;
                weakSelf.dismissAnimated = animated;
                weakSelf.dismissResolve = resolve;
                [hostView dismissViewController];
            } else {
                resolve(nil);
            }
        } else {
            reject(@"parameters error", [NSString stringWithFormat:@"invalid parameter: %@", [reactTag stringValue]], nil);
        }
    }];
}

#pragma mark - RCTInvalidating

- (void)invalidate {
    for (RNPopoverHostView *hostView in _hostViews) {
        [hostView invalidate];
    }
    [_hostViews removeAllObjects];
}

#pragma mark - RNPopoverHostViewInteractor

- (void)presentPopoverHostView:(RNPopoverHostView *_Nullable)popoverHostView
            withViewController:(RNPopoverHostViewController *_Nonnull)viewController
          parentViewController:(RNPopoverHostViewController *_Nonnull)parentViewController
                      animated:(BOOL)animated {
    dispatch_block_t completionBlock = ^{
        if (popoverHostView.onShow) {
            popoverHostView.onShow(nil);
            popoverHostView.onShow = nil;
        }
    };
    
    [parentViewController presentViewController:viewController animated:animated completion:completionBlock];
}

- (void)dismissPopoverHostView:(RNPopoverHostView *_Nullable)popoverHostView
            withViewController:(RNPopoverHostViewController *_Nullable)viewController
                      animated:(BOOL)animated {
    [self dismissPopoverHostView:popoverHostView withViewController:viewController animated:animated completion:nil];
}


- (void)dismissPopoverHostView:(RNPopoverHostView *_Nullable)popoverHostView
            withViewController:(RNPopoverHostViewController *_Nullable)viewController
                      animated:(BOOL)animated
                    completion: (void (^ __nullable)(void))completion {
    __weak typeof(self) weakSelf = self;
    [viewController dismissViewControllerAnimated: self.userDismiss ? self.dismissAnimated : animated completion:^{
        if (weakSelf.dismissResolve) {
            weakSelf.dismissResolve(nil);
            weakSelf.dismissResolve = nil;
        }
        if (popoverHostView.onHide) {
            popoverHostView.onHide(nil);
        }
        weakSelf.userDismiss = NO;
        
        if (completion) {
            completion();
        }
    }];
}


- (void)lookupViewForNativeID:(NSString *)nativeID :(void (^)(UIView *view, RNPopoverHostView *popoverHostView))completion
{
    for (RNPopoverHostView *hostView in _hostViews) {
        UIView *target = [self lookupViewForNativeID:nativeID inView:hostView.contentView];
        if (target) {
            completion(target, hostView);
        }
    }
}

- (UIView *)lookupViewForNativeID:(NSString *)nativeID inView:(UIView *)view
{
    RCTAssertMainQueue();
    if (view != nil && [nativeID isEqualToString:view.nativeID]) {
        return view;
    }
    
    for (UIView *subview in view.subviews) {
        UIView *targetView = [self lookupViewForNativeID:nativeID inView:subview];
        if (targetView != nil) {
            return targetView;
        }
    }
    return nil;
}

#pragma mark - Private

- (UIViewController *)topViewController {
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}


@end
