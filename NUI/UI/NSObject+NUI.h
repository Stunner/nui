//
//  NSObject+NUI.h
//  NUIDemo
//
//  Created by Aaron Jubbal on 8/5/15.
//  Copyright (c) 2015 Tom Benner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUISettings.h"

@interface NSObject (NUI)

@property (nonatomic, copy) NUIRenderOverrideBlock renderOverrideBlock;

@end
