//
//  NUITabBarItemRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 12/9/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITabBarItemRenderer.h"

@implementation NUITabBarItemRenderer

+ (void)render:(UITabBarItem*)item withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:item withClass:className];
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];

    if ([[titleTextAttributes allKeys] count] > 0) {
        [item setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }

    NSDictionary *selectedTextAttributes = [NUIUtilities titleTextAttributesForClass:className withSuffix:@"selected"];

    if ([[selectedTextAttributes allKeys] count] > 0) {
        [item setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    }

    if ([NUISettings hasProperty:kTextOffset withClass:className]) {
        [item setTitlePositionAdjustment:[NUISettings getOffset:kTextOffset withClass:className]];
    }

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
    if ([NUISettings hasProperty:kFinishedImage withClass:className]) {
        UIImage *unselectedFinishedImage = [[NUISettings getImage:kFinishedImage withClass:className] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setImage:unselectedFinishedImage];
    }
    
    if ([NUISettings hasProperty:kFinishedImageSelected withClass:className]) {
        UIImage *selectedFinishedImage = [[NUISettings getImage:kFinishedImageSelected withClass:className] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [item setSelectedImage:selectedFinishedImage];
    }
#else
    if ([NUISettings hasProperty:kFinishedImage withClass:className]) {
        UIImage *unselectedFinishedImage = [NUISettings getImage:kFinishedImage withClass:className];
        UIImage *selectedFinishedImage = unselectedFinishedImage;
        
        if ([NUISettings hasProperty:kFinishedImageSelected withClass:className]) {
            selectedFinishedImage = [NUISettings getImage:kFinishedImageSelected withClass:className];
        }
        
        [item setFinishedSelectedImage:selectedFinishedImage withFinishedUnselectedImage:unselectedFinishedImage];
    }
#endif
}

@end
