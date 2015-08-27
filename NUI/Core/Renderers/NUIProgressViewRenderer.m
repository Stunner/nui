//
//  NUIProgressViewRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 3/17/13.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "NUIProgressViewRenderer.h"

@implementation NUIProgressViewRenderer

+(void)render:(UIProgressView*)progressView
{
    [self render:progressView withClass:@"Progress"];
}

+(void)render:(UIProgressView*)progressView withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:progressView withClass:className];
    
    if ([NUISettings hasProperty:kProgressTintColor withClass:className]) {
        [progressView setProgressTintColor:[NUISettings getColor:kProgressTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kProgressImage withClass:className]) {
        [progressView setProgressImage:[NUISettings getImage:kProgressImage withClass:className]];
    }
    
    if ([NUISettings hasProperty:kTrackTintColor withClass:className]) {
        [progressView setTrackTintColor:[NUISettings getColor:kTrackTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kTrackImage withClass:className]) {
        [progressView setTrackImage:[NUISettings getImage:kTrackImage withClass:className]];
    }
    
    [NUIViewRenderer renderSize:progressView withClass:className];
}

@end
