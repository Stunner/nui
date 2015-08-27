//
//  NUINavigationBarRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUINavigationBarRenderer.h"

@implementation NUINavigationBarRenderer

+ (void)render:(UINavigationBar*)bar withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:bar withClass:className];
    
    if ([bar respondsToSelector:@selector(setBarTintColor:)]) {
        if ([NUISettings hasProperty:kBarTintColor withClass:className]) {
            [bar setBarTintColor:[NUISettings getColor:kBarTintColor withClass:className]];
        }
    }
    
    if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
        [bar setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    }

    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className] forBarMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kShadowImage withClass:className]) {
        [bar setShadowImage:[NUISettings getImage:kShadowImage withClass:className]];
    }

    NSString *property = kTitleVerticalOffset;
    if ([NUISettings hasProperty:property withClass:className]) {
        float offset = [NUISettings getFloat:property withClass:className];
        [bar setTitleVerticalPositionAdjustment:offset forBarMetrics:UIBarMetricsDefault];
    }

    [self renderSizeDependentProperties:bar];

    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];

    if ([[titleTextAttributes allKeys] count] > 0) {
        bar.titleTextAttributes = titleTextAttributes;
    }
}

+ (void)sizeDidChange:(UINavigationBar*)bar
{
    [self renderSizeDependentProperties:bar];
}

+ (void)renderSizeDependentProperties:(UINavigationBar*)bar
{
    NSString *className = bar.nuiClass;

    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        CGRect frame = bar.bounds;
        UIImage *gradientImage = [NUIGraphics
                                  gradientImageWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                  bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                  frame:frame];
        [bar setBackgroundImage:gradientImage forBarMetrics:UIBarMetricsDefault];
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        CGRect frame = bar.bounds;
        UIImage *colorImage = [NUIGraphics colorImage:[NUISettings getColor:kBackgroundColor withClass:className] withFrame:frame];
        [bar setBackgroundImage:colorImage forBarMetrics:UIBarMetricsDefault];
    }
}

@end
