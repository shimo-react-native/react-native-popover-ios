//
//  RNPopoverTargetManager.h
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/23.
//  Copyright © 2017年 shimo.im. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView * (^RNPViewGetterBlock)(NSInteger tag);

@interface RNPopoverTargetManager : NSObject

@property (nonatomic, strong, readonly) NSMapTable *tagViewMapTable;
@property (nonatomic, strong, readonly) NSMapTable *viewTagMapTable;
@property (nonatomic, assign, readonly) NSUInteger maxTag;

+ (instancetype)getInstance;

- (__kindof UIView *)viewForTag:(NSUInteger)tag;
- (NSUInteger)tagForView:(__kindof UIView *)view;
- (NSUInteger)autoSetTagForView:(__kindof UIView *)view;
- (BOOL)setTag:(NSInteger)tag forView:(__kindof UIView *)view;

- (BOOL)setGetterTag:(NSInteger)getterTag forGetter:(RNPViewGetterBlock)getter;
- (RNPViewGetterBlock)getterForGetterTag:(NSUInteger)getterTag;
- (__kindof UIView *)viewForGetterTag:(NSUInteger)getterTag;

@end
