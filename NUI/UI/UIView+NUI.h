//
//  UIView+NUI.h
//  NUIDemo
//
//  Created by Tom Benner on 12/9/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "NUIRenderer.h"
//#import "NUIRenderContainer.h"

@interface UIView (NUI)

@property (nonatomic, retain) NSString* nuiClass;
@property (nonatomic, assign, getter = isNUIApplied) BOOL nuiApplied;

- (void)applyNUI;
- (void)appendClass:(NSString *)nuiClass;

@end
