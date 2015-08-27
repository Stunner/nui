//
//  NUISearchBarRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 1/11/13.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "NUISearchBarRenderer.h"

@implementation NUISearchBarRenderer

+ (void)render:(UISearchBar*)bar withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:bar withClass:className];
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImageFromColor:kBackgroundColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
        [bar setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        UIImage *gradientImage = [NUIGraphics
                                          gradientImageWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                          bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                          frame:bar.bounds];
        [bar setBackgroundImage:gradientImage];
    }
    
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [bar setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className]];
    }
    
    // Render scope bar
    
    if ([NUISettings hasProperty:kScopeBackgroundColor withClass:className]) {
        [bar setScopeBarBackgroundImage:[NUISettings getImageFromColor:kScopeBackgroundColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kScopeBackgroundImage withClass:className]) {
        [bar setScopeBarBackgroundImage:[NUISettings getImage:kScopeBackgroundImage withClass:className]];
    }
    
    NSString *scopeBarClassName = [NSString stringWithFormat:@"SegmentedControl:%@ScopeBar", className];
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:scopeBarClassName];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [bar setScopeBarButtonTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:scopeBarClassName] ||
        [NUISettings hasProperty:kBorderColor withClass:scopeBarClassName]) {
        CALayer *layer = [NUIGraphics roundedRectLayerWithClass:scopeBarClassName size:bar.bounds.size];
        UIImage *normalImage = [NUIGraphics roundedRectImageWithClass:scopeBarClassName layer:layer];
        
        if ([NUISettings hasProperty:kBackgroundColorSelected withClass:scopeBarClassName]) {
            [layer setBackgroundColor:[[NUISettings getColor:kBackgroundColorSelected withClass:scopeBarClassName] CGColor]];
        }
        UIImage *selectedImage = [NUIGraphics roundedRectImageWithClass:scopeBarClassName layer:layer];
        [bar setScopeBarButtonBackgroundImage:normalImage forState:UIControlStateNormal];
        [bar setScopeBarButtonBackgroundImage:selectedImage forState:UIControlStateSelected];
        
        if ([NUISettings hasProperty:kBorderColor withClass:scopeBarClassName]) {
            [bar setScopeBarButtonDividerImage:[NUISettings getImageFromColor:kBorderColor withClass:scopeBarClassName] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal];
        }
    }
    
}

@end
