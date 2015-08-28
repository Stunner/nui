//
//  NUIViewRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIViewRenderer.h"
#import "NUILayerRenderer.h"

@implementation NUIViewRenderer

+ (void)render:(UIView*)view withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:view withClass:className];
    
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        if ([NUISettings hasProperty:kBackgroundRepeat withClass:className] && ![NUISettings getBoolean:kBackgroundRepeat withClass:className]) {
            view.layer.contents = (__bridge id)[NUISettings getImage:kBackgroundImage withClass:className].CGImage;
        } else {
            [view setBackgroundColor: [NUISettings getColorFromImage:kBackgroundImage withClass:className]];
        }
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [view setBackgroundColor: [NUISettings getColor:kBackgroundColor withClass:className]];
    }

    if ([NUISettings hasProperty:@"tint-color" withClass:className]) {
        [view setTintColor:[NUISettings getColor:@"tint-color" withClass:className]];
    }
    
    [self renderSize:view withClass:className];
    [self renderBorderAndCorner:view withClass:className];
    [self renderShadow:view withClass:className];
}

+ (void)renderBorderAndCorner:(UIView*)view withClass:(NSString*)className
{
    CALayer *layer = [view layer];

    if ([NUISettings hasProperty:@"borders" withClass:className]) {
        
        [NUILayerRenderer renderLayer:layer withClass:className];
        // Set the view backgroundColor to clearColor because the color has been transferred to the Layer
        [view setBackgroundColor:[UIColor clearColor]];
    } else {
        if ([NUISettings hasProperty:kBorderColor withClass:className]) {
            [layer setBorderColor:[[NUISettings getColor:kBorderColor withClass:className] CGColor]];
        }
    
        if ([NUISettings hasProperty:kBorderWidth withClass:className]) {
            [layer setBorderWidth:[NUISettings getFloat:kBorderWidth withClass:className]];
        }
        
        if ([NUISettings hasProperty:@"corners" withClass:className]) {
            UIEdgeInsets corners = [NUISettings getEdgeInsets:@"corners" withClass:className];
            float cornerRadius = [self calculateCornerRadius:corners withClass:className];
            [self renderRoundCorners:view onTopLeft:corners.top > 0 topRight:corners.right > 0 bottomLeft:corners.left > 0 bottomRight:corners.bottom > 0 radius:cornerRadius];
        } else {
            if ([NUISettings hasProperty:kCornerRadius withClass:className]) {
                [layer setCornerRadius:[NUISettings getFloat:kCornerRadius withClass:className]];
                layer.masksToBounds = YES;
            }
        }
    }
}

+ (void)renderRoundCorners:(UIView *)view onTopLeft:(BOOL)tl topRight:(BOOL)tr bottomLeft:(BOOL)bl bottomRight:(BOOL)br radius:(float)radius {

    if (tl || tr || bl || br) {
        UIRectCorner corner = 0; //holds the corner
        //Determine which corner(s) should be changed
        if (tl) {
            corner = corner | UIRectCornerTopLeft;
        }
        if (tr) {
            corner = corner | UIRectCornerTopRight;
        }
        if (bl) {
            corner = corner | UIRectCornerBottomLeft;
        }
        if (br) {
            corner = corner | UIRectCornerBottomRight;
        }

        UIView *roundedView = view;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:roundedView.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(radius, radius)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = roundedView.bounds;
        maskLayer.path = maskPath.CGPath;
        roundedView.layer.mask = maskLayer;

        CAShapeLayer *frameLayer = [CAShapeLayer layer];
        frameLayer.frame = roundedView.bounds;
        frameLayer.path = maskPath.CGPath;
        frameLayer.strokeColor = roundedView.layer.borderColor;
        frameLayer.lineWidth = roundedView.layer.borderWidth*2;
        frameLayer.fillColor = nil;

        [view.layer addSublayer:frameLayer];
    }
}

+ (float)calculateCornerRadius:(UIEdgeInsets)corners withClass:(NSString *)className {

    if ([NUISettings hasProperty:kCornerRadius withClass:className]) {
        return [NUISettings getFloat:kCornerRadius withClass:className];
    }

    NSArray *cornersArray = @[@(corners.top), @(corners.left), @(corners.right), @(corners.bottom)];

    return [[cornersArray valueForKeyPath:@"@max.self"] floatValue];
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
