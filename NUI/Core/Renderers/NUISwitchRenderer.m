//
//  NUISwitchRenderer.m
//  NUIDemo
//
//  Created by Benjamin Clayton on 04/01/2013.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "NUISwitchRenderer.h"

@implementation NUISwitchRenderer

+ (void)render:(UISwitch*)uiSwitch withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:uiSwitch withClass:className];
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [uiSwitch setBackgroundColor:[NUISettings getColor:kBackgroundColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kOffImage withClass:className]) {
        [uiSwitch setOffImage:[NUISettings getImage:kOffImage withClass:className]];
    }
    
    if ([NUISettings hasProperty:kOnImage withClass:className]) {
        [uiSwitch setOnImage:[NUISettings getImage:kOnImage withClass:className]];
    }
    
    if ([NUISettings hasProperty:kOnTintColor withClass:className]) {
        [uiSwitch setOnTintColor:[NUISettings getColor:kOnTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kThumbTintColor withClass:className]) {
        [uiSwitch setThumbTintColor:[NUISettings getColor:kThumbTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kTintColor withClass:className]) {
        [uiSwitch setTintColor:[NUISettings getColor:kTintColor withClass:className]];
    }
}

@end
