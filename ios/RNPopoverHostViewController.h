//
//  RNPopoverHostViewController.h
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/10.
//  Copyright © 2017年 shimo.im. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RNPopoverHostViewController;

@protocol RNPopoverHostViewControllerDelegate <NSObject>

- (void)didContentFrameUpdated:(RNPopoverHostViewController *)viewController;

@end

@interface RNPopoverHostViewController : UIViewController

@property (nonatomic, assign) CGRect contentFrame;
@property (nonatomic, weak) id<RNPopoverHostViewControllerDelegate> popoverHostDelegate;

@end
