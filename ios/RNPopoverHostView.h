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
 reactTag for The view containing the anchor rectangle for the popover.
 
 @see https://developer.apple.com/documentation/uikit/uipopoverpresentationcontroller/1622313-sourceview
 */
@property (nonatomic, assign) NSInteger sourceView;

/**
 The rectangle in the specified view in which to anchor the popover.
 
 @see https://developer.apple.com/documentation/uikit/uipopoverpresentationcontroller/1622324-sourcerect
 */
@property (nonatomic, assign) CGRect sourceRect;

/**
 The arrow directions that you prefer for the popover.
 
 0: UIPopoverArrowDirectionUp = 1UL << 0,
 1: UIPopoverArrowDirectionDown = 1UL << 1,
 2: UIPopoverArrowDirectionLeft = 1UL << 2,
 3: UIPopoverArrowDirectionRight = 1UL << 3,
 
 default: [0, 1, 2, 3]
 
 @see https://developer.apple.com/documentation/uikit/uipopoverpresentationcontroller/1622319-permittedarrowdirections
 */
@property (nullable, nonatomic, strong) NSArray *permittedArrowDirections;

/**
 The preferred size for the view controller’s view.
 
 @see https://developer.apple.com/documentation/uikit/uiviewcontroller/1621476-preferredcontentsize
 */
@property (nonatomic, assign) CGSize preferredContentSize;
@property (nullable, nonatomic, copy) RCTDirectEventBlock onShow;
@property (nullable, nonatomic, copy) RCTDirectEventBlock onHide;

#pragma mark - Method

- (instancetype _Nonnull )initWithBridge:(RCTBridge *_Nullable)bridge NS_DESIGNATED_INITIALIZER;

@end
