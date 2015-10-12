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
    [NUISettings checkUnsupportedPropertiesForObject:view withClass:className];
    
    NSString *propertyName = kBackgroundImage;
    NSString *propertyName2 = kBackgroundColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            if ([NUISettings hasProperty:kBackgroundRepeat withClass:className] && ![NUISettings getBoolean:kBackgroundRepeat withClass:className]) {
                view.layer.contents = (__bridge id)[NUISettings getImage:propertyName withClass:className].CGImage;
            } else {
                [view setBackgroundColor:[NUISettings getColorFromImage:propertyName withClass:className]];
            }
        }
    } else if ([NUISettings hasProperty:propertyName2 withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName2 withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName2 withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [view setBackgroundColor:[NUISettings getColor:propertyName2 withClass:className]];
        }
    }

    propertyName = kTintColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [view setTintColor:[NUISettings getColor:propertyName withClass:className]];
        }
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
    
    NSString *propertyName = kShadowRadius;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        float appliedProperty = [NUISettings getFloat:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:@(appliedProperty)];
        if (applyStyle) {
            [layer setShadowRadius:[NUISettings getFloat:propertyName withClass:className]];
        }
    }
    propertyName = kShadowOffset;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        CGSize appliedProperty = [NUISettings getSize:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:[NSValue valueWithCGSize:appliedProperty]];
        if (applyStyle) {
            [layer setShadowOffset:[NUISettings getSize:propertyName withClass:className]];
        }
    }
    
    propertyName = kShadowColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [layer setShadowColor:[NUISettings getColor:propertyName withClass:className].CGColor];
        }
    }
    
    propertyName = kShadowOpacity;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        float appliedProperty = [NUISettings getFloat:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:view forState:UIControlStateNormal
                                     appliedProperty:@(appliedProperty)];
        if (applyStyle) {
            [layer setShadowOpacity:[NUISettings getFloat:propertyName withClass:className]];
        }
    }
}

// TODO: add render override support
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
