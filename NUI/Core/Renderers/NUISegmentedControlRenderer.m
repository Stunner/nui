//
//  NUISegmentedControlRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUISegmentedControlRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUISegmentedControlRenderer

+ (void)render:(UISegmentedControl*)control withClass:(NSString*)className
{
    [NUIViewRenderer renderSize:control withClass:className];
  
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
            [control setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
        if ([NUISettings hasProperty:kBackgroundImageSelected withClass:className]) {
            [control setBackgroundImage:[NUISettings getImage:kBackgroundImageSelected withClass:className] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        }
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className] ||
               [NUISettings hasProperty:kBorderColor withClass:className]) {
        CALayer *layer = [NUIGraphics roundedRectLayerWithClass:className size:control.bounds.size];
        UIImage *normalImage = [NUIGraphics roundedRectImageWithClass:className layer:layer];
        
        if ([NUISettings hasProperty:kBackgroundColorSelected withClass:className]) {
            [layer setBackgroundColor:[[NUISettings getColor:kBackgroundColorSelected withClass:className] CGColor]];
        }
        UIImage *selectedImage = [NUIGraphics roundedRectImageWithClass:className layer:layer];
        [control setBackgroundImage:normalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [control setBackgroundImage:selectedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
        if ([NUISettings hasProperty:kBorderColor withClass:className]) {
            [control setDividerImage:[NUISettings getImageFromColor:kBorderColor withClass:className] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        }
    }
    
    // Set divider image or divider color
    if ([NUISettings hasProperty:kDividerImage withClass:className]) {
        [control setDividerImage:[NUISettings getImage:kDividerImage withClass:className] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    } else if ([NUISettings hasProperty:kDividerColor withClass:className]) {
        [control setDividerImage:[NUISettings getImageFromColor:kDividerColor withClass:className] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
    // Set background tint color
    if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
        // UISegmentedControlStyleBar is necessary for setTintColor to take effect
        control.segmentedControlStyle = UISegmentedControlStyleBar;
#endif
        [control setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    }
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [control setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    NSDictionary *selectedSegmentAttributeOverrides = [NUIUtilities titleTextAttributesForClass:className withSuffix:@"selected"];
    if ([[selectedSegmentAttributeOverrides allKeys] count] > 0) {
        NSMutableDictionary *selectedTitleTextAttributes = [titleTextAttributes mutableCopy];
        [selectedTitleTextAttributes addEntriesFromDictionary:selectedSegmentAttributeOverrides];
        [control setTitleTextAttributes:[selectedTitleTextAttributes copy] forState:UIControlStateSelected];
    }
}

@end
