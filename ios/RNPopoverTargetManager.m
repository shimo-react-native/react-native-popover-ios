//
//  RNPopoverTargetManager.m
//  RNPopoverIOS
//
//  Created by Bell Zhong on 2017/8/23.
//  Copyright © 2017年 shimo.im. All rights reserved.
//

#import "RNPopoverTargetManager.h"

@interface RNPopoverTargetManager ()

@property (nonatomic, strong) NSMapTable *tagViewMapTable;
@property (nonatomic, strong) NSMapTable *viewTagMapTable;
@property (nonatomic, assign) NSUInteger maxTag;

@end

@implementation RNPopoverTargetManager

+ (instancetype)getInstance {
    static RNPopoverTargetManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc] init];
    });
    return __manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _maxTag = 0;
        _tagViewMapTable = [NSMapTable strongToWeakObjectsMapTable];
        _viewTagMapTable = [NSMapTable strongToWeakObjectsMapTable];
    }
    return self;
}

- (__kindof UIView *)viewForTag:(NSUInteger)tag {
    return [_tagViewMapTable objectForKey:@(tag)];
}

- (NSUInteger)tagForView:(__kindof UIView *)view {
    NSNumber *tag = [_viewTagMapTable objectForKey:view];
    if (!tag) {
        return NSUIntegerMax;
    }
    return [tag integerValue];
}

- (NSUInteger)autoSetTagForView:(__kindof UIView *)view {
    NSUInteger tag = [self tagForView:view];
    if (tag != NSUIntegerMax) {
        return tag;
    }
    NSNumber *key = @(++_maxTag);
    [_tagViewMapTable setObject:view forKey:key];
    [_viewTagMapTable setObject:key forKey:view];
    return _maxTag;
}

- (BOOL)setTag:(NSInteger)tag forView:(__kindof UIView *)view {
    NSNumber *key = @(tag);
    [_tagViewMapTable setObject:view forKey:key];
    [_viewTagMapTable setObject:key forKey:view];
    
    _maxTag = MAX(_maxTag, tag);
    return YES;
}

@end
