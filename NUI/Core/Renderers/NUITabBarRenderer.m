//
//  NUITabBarRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITabBarRenderer.h"

@implementation NUITabBarRenderer

+ (void)render:(UITabBar*)bar withClass:(NSString*)className
{
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className]];
    }
    
    if ([NUISettings hasProperty:kSelectedImage withClass:className]) {
        [bar setSelectionIndicatorImage:[NUISettings getImage:kSelectedImage withClass:className]];
    }
    
    if ([NUISettings hasProperty:kSelectedImageTintColor withClass:className]) {
        [bar setSelectedImageTintColor:[NUISettings getColor:kSelectedImageTintColor withClass:className]];
    }
    
    [self renderSizeDependentProperties:bar];
    
    // Apply UITabBarItem's background-image-selected property to bar.selectionIndicatorImage
    if ([[bar items] count] > 0) {
        UITabBarItem *firstItem = [[bar items] objectAtIndex:0];
        NSArray *firstItemClasses = [firstItem.nuiClass componentsSeparatedByString: @":"];
        for (NSString *itemClass in firstItemClasses) {
            if ([NUISettings hasProperty:kBackgroundImageSelected withClass:itemClass]) {
                [bar setSelectionIndicatorImage:[NUISettings getImage:kBackgroundImageSelected withClass:itemClass]];
            }
        }
    }
    
    if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
        [bar setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [bar setBackgroundColor:[NUISettings getColor:kBackgroundColor withClass:className]];
    }
}

+ (void)sizeDidChange:(UITabBar*)bar
{
    [self renderSizeDependentProperties:bar];
}

+ (void)renderSizeDependentProperties:(UITabBar*)bar
{
    NSString *className = bar.nuiClass;
    
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        CGRect frame = bar.bounds;
        UIImage *gradientImage = [NUIGraphics
                                  gradientImageWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                  bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                  frame:frame];
        [bar setBackgroundImage:gradientImage];
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        CGRect frame = bar.bounds;
        UIImage *colorImage = [NUIGraphics colorImage:[NUISettings getColor:kBackgroundColor withClass:className] withFrame:frame];
        [bar setBackgroundImage:colorImage];
    }
}

@end
