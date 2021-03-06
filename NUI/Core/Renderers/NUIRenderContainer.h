//
//  NUIRenderContainer.h
//  NUIDemo
//
//  Created by Aaron Jubbal on 7/24/15.
//  Copyright (c) 2015 Tom Benner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NUIRenderContainer : NSObject

@property (nonatomic, assign) BOOL recognizedProperty;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *propertyValue;
// used for properties with two keys and values, like background gradient
@property (nonatomic, strong) NSString *secondaryPropertyName;
@property (nonatomic, strong) NSString *secondaryPropertyValue;
@property (nonatomic, strong) NSString *className;
@property (nonatomic, assign) UIControlState state;
@property (nonatomic, strong) id appliedProperty;

@end
