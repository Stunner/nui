//
//  NUIToolbarRenderer.m
//  NUIDemo
//
//  Created by Simon Moser on 09/01/13.
//  Copyright (c) 2013 Simon Moser. All rights reserved.
//

#import "NUIToolbarRenderer.h"

@implementation NUIToolbarRenderer

+ (void)render:(UIToolbar*)bar withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:bar withClass:className];
    
    // setBackgroundColor isn't applied correctly in all cases, so we'll use setBackgroundImage
    // instead
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImageFromColor:kBackgroundColor withClass:className] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    
    if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
        [bar setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kBackgroundImageTop withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImageTop withClass:className] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kBackgroundImageBottom withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImageBottom withClass:className] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kBackgroundImageTopLandscape withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImageTopLandscape withClass:className] forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsLandscapePhone];
    }
    if ([NUISettings hasProperty:kBackgroundImageBottomLandscape withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImageBottomLandscape withClass:className] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsLandscapePhone];
    }
    
    // setShadowImage is available since ios 6.0
    if ([bar respondsToSelector:@selector(setShadowImage:forToolbarPosition:)]) {
        if ([NUISettings hasProperty:kShadowImage withClass:className]) {
            [bar setShadowImage:[NUISettings getImage:kShadowImage withClass:className] forToolbarPosition:UIToolbarPositionAny];
        }
        if ([NUISettings hasProperty:kShadowImageTop withClass:className]) {
            [bar setShadowImage:[NUISettings getImage:kShadowImageTop withClass:className] forToolbarPosition:UIToolbarPositionTop];
        }
        if ([NUISettings hasProperty:kShadowImageBottom withClass:className]) {
            [bar setShadowImage:[NUISettings getImage:kShadowImageBottom withClass:className] forToolbarPosition:UIToolbarPositionBottom];
        }
    }
}

@end
