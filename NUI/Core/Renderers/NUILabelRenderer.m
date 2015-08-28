//
//  NUILabelRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUILabelRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUILabelRenderer

+ (void)render:(UILabel*)label withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:label withClass:className];
    
    [self render:label withClass:className withSuffix:@""];
}

+ (void)render:(UILabel*)label withClass:(NSString*)className withSuffix:(NSString*)suffix
{
    if (![suffix isEqualToString:@""]) {
        className = [NSString stringWithFormat:@"%@%@", className, suffix];
    }
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        label.backgroundColor = [NUISettings getColor:kBackgroundColor withClass:className];
    } else {
        // UILabels created programmatically have a white background by default
        if (!label.backgroundColor || [label.backgroundColor isEqual:[UIColor whiteColor]]) {
            label.backgroundColor = [UIColor clearColor];
        }
    }
    
    if ([NUISettings hasProperty:kFontColor withClass:className]) {
        label.textColor = [NUISettings getColor:kFontColor withClass:className];
    }
    
    if ([NUISettings hasProperty:kFontColorHighlighted withClass:className]) {
        label.highlightedTextColor = [NUISettings getColor:kFontColorHighlighted withClass:className];
    }

    [NUIViewRenderer renderSize:label withClass:className];
    [NUIViewRenderer renderBorderAndCorner:label withClass:className];
    [NUIViewRenderer renderShadow:label withClass:className];
    [self renderText:label withClass:className];
}

+ (void)renderText:(UILabel*)label withClass:(NSString*)className
{
    NSString *property;
    
    if ([NUISettings hasFontPropertiesWithClass:className]) {
        label.font = [NUISettings getFontWithClass:className baseFont:label.font];
    }
    
    property = kTextAlign;
    if ([NUISettings hasProperty:property withClass:className]) {
        label.textAlignment = [NUISettings getTextAlignment:property withClass:className];
    }
    
    property = kTextAlpha;
    if ([NUISettings hasProperty:property withClass:className]) {
        label.alpha = [NUISettings getFloat:property withClass:className];
    }
    
    property = kTextAutoFit;
    if ([NUISettings hasProperty:property withClass:className]) {
        [label setAdjustsFontSizeToFitWidth:[NUISettings getBoolean:property withClass:className]];
    }
    
    property = kTextShadowColor;
    if ([NUISettings hasProperty:property withClass:className]) {
        label.shadowColor = [NUISettings getColor:property withClass:className];
    }
    
    property = kTextShadowOffset;
    if ([NUISettings hasProperty:property withClass:className]) {
        label.shadowOffset = [NUISettings getSize:property withClass:className];
    }
}

+ (BOOL)needsTextTransformWithClass:(NSString*)className
{
    return [NUISettings hasProperty:kTextTransform withClass:className];
}

+ (NSString *)transformText:(NSString*)text withClass:(NSString*)className
{
    if (![self needsTextTransformWithClass:className])
        return text;
    
    NSString *property;
    NSString *transformedText = text;
    
    property = kTextTransform;
    
    if ([NUISettings hasProperty:property withClass:className]) {
        NSString *transform = [NUISettings get:property withClass:className];
        
        if ([transform isEqualToString:@"uppercase"]) {
            transformedText = [text uppercaseString];
        } else if ([transform isEqualToString:@"lowercase"]) {
            transformedText = [text lowercaseString];
        } else if ([transform isEqualToString:@"capitalize"]) {
            transformedText = [text capitalizedString];
        }
    }
    
    return transformedText;
}

+ (NSAttributedString *)transformAttributedText:(NSAttributedString*)attributedText withClass:(NSString*)className
{
    if (![self needsTextTransformWithClass:className])
        return attributedText;
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    [attributedText enumerateAttributesInRange:NSMakeRange(0, attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        [attributes addObject:@{@"attrs":attrs, @"range":[NSValue valueWithRange:range]}];
    }];
    
    NSString *transformedText = [self transformText:[attributedText string] withClass:className];
    
    NSMutableAttributedString *transformedAttributedText = [attributedText mutableCopy];
    [transformedAttributedText replaceCharactersInRange:NSMakeRange(0, transformedAttributedText.length) withString:transformedText];
    
    for (NSDictionary *attribute in attributes) {
        [transformedAttributedText setAttributes:attribute[@"attrs"] range:[attribute[@"range"] rangeValue]];
    }

    return transformedAttributedText;
}

@end
