//
//  NUIViewRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIViewRenderer.h"

@implementation NUIViewRenderer

+ (void)render:(UIView*)view withClass:(NSString*)className
{
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        if ([NUISettings hasProperty:kBackgroundRepeat withClass:className] && ![NUISettings getBoolean:kBackgroundRepeat withClass:className]) {
            view.layer.contents = (__bridge id)[NUISettings getImage:kBackgroundImage withClass:className].CGImage;
        } else {
            [view setBackgroundColor: [NUISettings getColorFromImage:kBackgroundImage withClass:className]];
        }
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [view setBackgroundColor: [NUISettings getColor:kBackgroundColor withClass:className]];
    }

    [self renderSize:view withClass:className];
    [self renderBorder:view withClass:className];
    [self renderShadow:view withClass:className];
}

+ (void)renderBorder:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];
    
    if ([NUISettings hasProperty:kBorderColor withClass:className]) {
        [layer setBorderColor:[[NUISettings getColor:kBorderColor withClass:className] CGColor]];
    }
    
    if ([NUISettings hasProperty:kBorderWidth withClass:className]) {
        [layer setBorderWidth:[NUISettings getFloat:kBorderWidth withClass:className]];
    }
    
    if ([NUISettings hasProperty:kCornerRadius withClass:className]) {
        [layer setCornerRadius:[NUISettings getFloat:kCornerRadius withClass:className]];
        layer.masksToBounds = YES;
    }
}

+ (void)renderShadow:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];
    
    if ([NUISettings hasProperty:kShadowRadius withClass:className]) {
        [layer setShadowRadius:[NUISettings getFloat:kShadowRadius withClass:className]];
    }
    
    if ([NUISettings hasProperty:kShadowOffset withClass:className]) {
        [layer setShadowOffset:[NUISettings getSize:kShadowOffset withClass:className]];
    }
    
    if ([NUISettings hasProperty:kShadowColor withClass:className]) {
        [layer setShadowColor:[NUISettings getColor:kShadowColor withClass:className].CGColor];
    }
    
    if ([NUISettings hasProperty:kShadowOpacity withClass:className]) {
        [layer setShadowOpacity:[NUISettings getFloat:kShadowOpacity withClass:className]];
    }
}

+ (void)renderSize:(UIView*)view withClass:(NSString*)className
{
    CGFloat height = view.frame.size.height;
    if ([NUISettings hasProperty:kHeight withClass:className]) {
        height = [NUISettings getFloat:kHeight withClass:className];
    }
    
    CGFloat width = view.frame.size.width;
    if ([NUISettings hasProperty:kWidth withClass:className]) {
        width = [NUISettings getFloat:kWidth withClass:className];
    }

    if (height != view.frame.size.height || width != view.frame.size.width) {
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, width, height);
    }
}

+ (BOOL)hasShadowProperties:(UIView*)view withClass:(NSString*)className {
    
    BOOL hasAnyShadowProperty = NO;
    for (NSString *property in @[kShadowRadius, kShadowOffset, kShadowColor, kShadowOpacity]) {
        hasAnyShadowProperty |= [NUISettings hasProperty:property withClass:className];
    }
    return hasAnyShadowProperty;
}

@end
