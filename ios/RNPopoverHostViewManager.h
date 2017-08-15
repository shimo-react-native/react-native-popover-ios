//
//  RNPopoverHostViewManager.h
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/10.
//  Copyright © 2017年 shimo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <React/RCTInvalidating.h>
#import <React/RCTViewManager.h>

typedef void (^RCTModalViewInteractionBlock)(UIViewController *reactViewController, UIViewController *viewController, BOOL animated, dispatch_block_t completionBlock);

@interface RNPopoverHostViewManager : RCTViewManager <RCTInvalidating>

@end
