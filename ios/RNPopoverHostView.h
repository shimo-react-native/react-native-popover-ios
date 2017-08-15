//
//  RNPopoverHostView.h
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/10.
//  Copyright © 2017年 shimo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <React/RCTInvalidating.h>
#import <React/RCTView.h>

@class RCTBridge;
@class RNPopoverHostView;
@class RNPopoverHostViewController;

@protocol RNPopoverHostViewInteractor <NSObject>

- (void)presentPopoverHostView:(RNPopoverHostView *_Nullable)popoverHostView withViewController:(RNPopoverHostViewController *_Nonnull)viewController animated:(BOOL)animated;
- (void)dismissPopoverHostView:(RNPopoverHostView *_Nullable)popoverHostView withViewController:(RNPopoverHostViewController *_Nullable)viewController animated:(BOOL)animated;

@end

@interface RNPopoverHostView : RCTView <RCTInvalidating, UIPopoverPresentationControllerDelegate>

@property (nullable, nonatomic, weak) id <RNPopoverHostViewInteractor> delegate;

#pragma mark - prop

@property (nonatomic, assign) BOOL animated;
@property (nullable, nonatomic, strong) UIColor *backgroundColor;

/**
 reactTag for sourceView
 */
@property (nonatomic, assign) NSInteger sourceViewReactTag;

/**
 0: UIPopoverArrowDirectionUp = 1UL << 0,
 1: UIPopoverArrowDirectionDown = 1UL << 1,
 2: UIPopoverArrowDirectionLeft = 1UL << 2,
 3: UIPopoverArrowDirectionRight = 1UL << 3,
 default: [0, 1, 2, 3]
 */
@property (nullable, nonatomic, strong) NSArray *permittedArrowDirections;
@property (nonatomic, assign) CGSize preferredContentSize;
@property (nullable, nonatomic, copy) RCTDirectEventBlock onShow;
@property (nullable, nonatomic, copy) RCTDirectEventBlock onHide;

#pragma mark - Method

- (instancetype _Nonnull )initWithBridge:(RCTBridge *_Nullable)bridge NS_DESIGNATED_INITIALIZER;

@end
