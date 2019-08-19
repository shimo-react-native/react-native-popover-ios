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
#import <React/RCTBridgeModule.h>

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

@property (nonatomic, assign) BOOL cancelable;
@property (nullable, nonatomic, strong) UIColor *popoverBackgroundColor;

/**
 tag for the native view containing the anchor rectangle for the popover.
 */
@property (nonatomic, assign) NSInteger sourceViewTag;

/**
 tag for the native view getter containing the anchor rectangle for the popover.
 */
@property (nonatomic, assign) NSInteger sourceViewGetterTag;

/**
 nativeID for the native view containing the anchor rectangle for the popover.
 */
@property (nonatomic, assign) NSString *sourceViewNativeID;

/**
 reactTag for the react view containing the anchor rectangle for the popover.
 
 @see https://developer.apple.com/documentation/uikit/uipopoverpresentationcontroller/1622313-sourceview
 */
@property (nonatomic, assign) NSInteger sourceViewReactTag;

/**
 The rectangle in the specified view in which to anchor the popover.
 
 @see https://developer.apple.com/documentation/uikit/uipopoverpresentationcontroller/1622324-sourcerect
 */
@property (nullable, nonatomic, strong) NSArray *sourceRect;

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
@property (nullable, nonatomic, strong) NSArray *preferredContentSize;
@property (nullable, nonatomic, copy) RCTDirectEventBlock onShow;
@property (nullable, nonatomic, copy) RCTDirectEventBlock onHide;


#pragma mark - readonly

@property (nonatomic, assign, readonly) BOOL presented;

#pragma mark - Method

- (instancetype _Nonnull )initWithBridge:(RCTBridge *_Nullable)bridge NS_DESIGNATED_INITIALIZER;

- (void)dismissViewController;

@end
