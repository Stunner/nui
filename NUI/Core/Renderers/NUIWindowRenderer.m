//
//  NUIWindowRenderer.m
//
//  Created by Julien Phalip on 01/27/13.
//  Copyright (c) 2013 Julien Phalip. All rights reserved.
//

#import "NUIWindowRenderer.h"

@implementation NUIWindowRenderer

+ (void)render:(UIWindow*)window withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:window withClass:className];
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [window.rootViewController.view setBackgroundColor:[NUISettings getColor:kBackgroundColor withClass:className]];
    }
}

@end

