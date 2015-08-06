//
//  NUIBarButtonItemRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIBarButtonItemRenderer.h"
#import "UIBarButtonItem+NUI.h"

@implementation NUIBarButtonItemRenderer

+ (void)render:(UIBarButtonItem*)item withClass:(NSString*)className
{
    
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [item setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    } else if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
        [item setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className] ||
               [NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        CALayer *layer = [CALayer layer];
        [layer setFrame:CGRectMake(0, 0, 30, 26)];
        [layer setMasksToBounds:YES];
        
        if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
            CAGradientLayer *gradientLayer = [NUIGraphics
                                              gradientLayerWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                              bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                              frame:layer.frame];
            
            if (item.gradientLayer) {
                [layer replaceSublayer:item.gradientLayer with:gradientLayer];
            } else {
                int backgroundLayerIndex = 0;
                [layer insertSublayer:gradientLayer atIndex:backgroundLayerIndex];
            }
            
            item.gradientLayer = gradientLayer;
        }
        
        if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
            [layer setBackgroundColor:[[NUISettings getColor:kBackgroundColor withClass:className] CGColor]];
        }
        
        if ([NUISettings hasProperty:kBorderColor withClass:className]) {
            [layer setBorderColor:[[NUISettings getColor:kBorderColor withClass:className] CGColor]];
        }
        
        if ([NUISettings hasProperty:kBorderWidth withClass:className]) {
            [layer setBorderWidth:[NUISettings getFloat:kBorderWidth withClass:className]];
        }
        
        float cornerRadius = [NUISettings getFloat:kCornerRadius withClass:className];
        float insetLength = cornerRadius;
        
        if (cornerRadius < 5) {
            insetLength = 5;
        }
        insetLength += 3;
        
        if ([NUISettings hasProperty:kCornerRadius withClass:className]) {
            [layer setCornerRadius:[NUISettings getFloat:kCornerRadius withClass:className]];
        }
        
        UIEdgeInsets insets = UIEdgeInsetsMake(insetLength, insetLength, insetLength, insetLength);
        UIImage *image = [NUIGraphics caLayerToUIImage:layer];
        if ([image respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
            image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        } else {
            image = [image resizableImageWithCapInsets:insets];
        }
        
        [item setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        if ([NUISettings hasProperty:kBackgroundColorHighlighted withClass:className]) {
            CALayer *highlightedLayer = layer;
            highlightedLayer.backgroundColor = [NUISettings getColor:kBackgroundColorHighlighted withClass:className].CGColor;
            UIImage *highlightedImage = [NUIGraphics caLayerToUIImage:highlightedLayer];
            if ([highlightedImage respondsToSelector:@selector(resizableImageWithCapInsets:resizingMode:)]) {
                highlightedImage = [highlightedImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
            } else {
                highlightedImage = [highlightedImage resizableImageWithCapInsets:insets];
            }
            [item setBackgroundImage:highlightedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        }
    }
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [item setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
}

@end
