//
//  NSObject+NUI.m
//  NUIDemo
//
//  Created by Aaron Jubbal on 8/5/15.
//  Copyright (c) 2015 Tom Benner. All rights reserved.
//

#import "NSObject+NUI.h"
#import <objc/runtime.h>
#import "NUIConstants.h"

@implementation NSObject (NUI)

- (void)setRenderOverrideBlock:(NUIRenderOverrideBlock)renderOverrideBlock {
    objc_setAssociatedObject(self, kNUIAssociatedRenderOverrideKey, renderOverrideBlock, OBJC_ASSOCIATION_COPY);
}

- (NUIRenderOverrideBlock)renderOverrideBlock {
    return objc_getAssociatedObject(self, kNUIAssociatedRenderOverrideKey);
}

@end
