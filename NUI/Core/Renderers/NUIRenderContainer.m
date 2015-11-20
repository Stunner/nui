//
//  NUIRenderContainer.m
//  NUIDemo
//
//  Created by Aaron Jubbal on 7/24/15.
//  Copyright (c) 2015 Tom Benner. All rights reserved.
//

#import "NUIRenderContainer.h"

@implementation NUIRenderContainer

- (BOOL)isEqualToRenderContainer:(NUIRenderContainer *)container {
    if (self == container)
        return YES;
    if (self.recognizedProperty != container.recognizedProperty) {
        return NO;
    }
    if (self.object != container.object) {
        return NO;
    }
    if (![self.propertyName isEqualToString:container.propertyName]) {
        return NO;
    }
    if (![self.propertyValue isEqualToString:container.propertyValue]) {
        return NO;
    }
    if (self.secondaryPropertyName || container.secondaryPropertyName) {
        if (![self.secondaryPropertyName isEqualToString:container.secondaryPropertyName]) {
            return NO;
        }
    } else {
        // test for potential equality to nil
        if (self.secondaryPropertyName != container.secondaryPropertyName) {
            return NO;
        }
    }
    if (self.secondaryPropertyValue || container.secondaryPropertyValue) {
        if (![self.secondaryPropertyValue isEqualToString:container.secondaryPropertyValue]) {
            return NO;
        }
    } else {
        // test for potential equality to nil
        if (self.secondaryPropertyValue != container.secondaryPropertyValue) {
            return NO;
        }
    }
    if (![self.className isEqualToString:container.className]) {
        return NO;
    }
    if (self.state != container.state) {
        return NO;
    }
    if (self.appliedProperty != container.appliedProperty &&
        ![self.appliedProperty isEqual:container.appliedProperty])
    {
        return NO;
    }
    return YES;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToRenderContainer:other];
}

// reference for this implementation:http://stackoverflow.com/a/4393493/347339
- (NSUInteger)hash {
    NSUInteger result = 1;
    NSUInteger prime = 31;
    NSUInteger yesPrime = 1231;
    NSUInteger noPrime = 1237;
    
    result = prime * result + self.recognizedProperty ? yesPrime : noPrime;
    result = prime * result + [self.object hash];
    result = prime * result + [self.propertyName hash];
    result = prime * result + [self.propertyValue hash];
    result = prime * result + [self.secondaryPropertyName hash];
    result = prime * result + [self.secondaryPropertyValue hash];
    result = prime * result + [self.className hash];
    result = prime * result + self.state;
    result = prime * result + [self.appliedProperty hash];
    
    return result;
}

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
