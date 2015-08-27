//
//  NUISliderRenderer.m
//  NUIDemo
//
//  Created by Simon Moser @savage7 on 09/01/13.
//  Copyright (c) 2013 Simon Moser. All rights reserved.
//

#import "NUISliderRenderer.h"

@implementation NUISliderRenderer

+ (void)render:(UISlider*)slider withClass:(NSString*)className;
{
    [NUISettings checkUnsupportedPropertiesForObject:slider withClass:className];
    
    if ([NUISettings hasProperty:kMinimumTrackTintColor withClass:className]) {
        [slider setMinimumTrackTintColor:[NUISettings getColor:kMinimumTrackTintColor withClass:className]];
    }
    if ([NUISettings hasProperty:kMaximumTrackTintColor withClass:className]) {
        [slider setMaximumTrackTintColor:[NUISettings getColor:kMaximumTrackTintColor withClass:className]];
    }
    if ([NUISettings hasProperty:kMinimumValueImage withClass:className]) {
        [slider setMinimumValueImage:[NUISettings getImage:kMinimumValueImage withClass:className]];
    }
    if ([NUISettings hasProperty:kMaximumValueImage withClass:className]) {
        [slider setMaximumValueImage:[NUISettings getImage:kMaximumValueImage withClass:className]];
    }
    if ([NUISettings hasProperty:kThumbImage withClass:className]) {
        [slider setThumbImage:[NUISettings getImage:kThumbImage withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:kThumbTintColor withClass:className]) {
        [slider setThumbTintColor:[NUISettings getColor:kThumbTintColor withClass:className]];
    }
}

@end
