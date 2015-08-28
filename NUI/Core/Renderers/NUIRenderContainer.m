//
//  NUIRenderContainer.m
//  NUIDemo
//
//  Created by Aaron Jubbal on 7/24/15.
//  Copyright (c) 2015 Tom Benner. All rights reserved.
//

#import "NUIRenderContainer.h"

@implementation NUIRenderContainer

- (NSString *)description {
    return [NSString stringWithFormat:@"==NUIRenderContainer:==\nrecognized property: %d\n"
            @"object: %@\npropertyName: %@\nproperty value: %@\nsecondaryPropertyName: %@"
            @"\nsecondaryProperty value: %@\nclass name: %@\nstate: %lu\napplied property: %@\n"
            "===========",
            self.recognizedProperty, self.object, self.propertyName, self.propertyValue,
            self.secondaryPropertyName, self.secondaryPropertyValue, self.className,
            (unsigned long)self.state, self.appliedProperty];
}

@end
