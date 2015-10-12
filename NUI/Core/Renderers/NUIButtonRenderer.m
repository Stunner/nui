//
//  NUIButtonRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIButtonRenderer.h"
#import "NUIViewRenderer.h"
#import "UIButton+NUI.h"
#import "NSObject+NUI.h"

@implementation NUIButtonRenderer

+ (void)render:(UIButton*)button withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:button withClass:className];
    
    [NUIViewRenderer renderSize:button withClass:className];
    // UIButtonTypeRoundedRect's first two sublayers contain its background and border, which
    // need to be hidden for NUI's rendering to be displayed correctly. Ideally we would switch
    // over to a UIButtonTypeCustom, but this appears to be impossible.
    if (button.buttonType == UIButtonTypeRoundedRect) {
        if ([button.layer.sublayers count] > 2) {
            [button.layer.sublayers[0] setOpacity:0.0f];
            [button.layer.sublayers[1] setOpacity:0.0f];
        }
    }

    // Set padding
    if ([NUISettings hasProperty:kPadding withClass:className]) {
        [button setTitleEdgeInsets:[NUISettings getEdgeInsets:kPadding withClass:className]];
    }
    
    // Because Cocoa Touch does not provide setBackgroundColor:forState: as a method for UIButton, by default, a hack
    // must be used to do this using a colored image instead.
    
    // Set background color
    NSString *propertyName = kBackgroundColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateNormal
                                     appliedProperty:[NUISettings getColor:propertyName withClass:className]];
        if (applyStyle) {
            [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                              forState:UIControlStateNormal];
        }
    }
    propertyName = kBackgroundColorHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateHighlighted
                                     appliedProperty:[NUISettings getColor:propertyName withClass:className]];
        if (applyStyle) {
            [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                              forState:UIControlStateHighlighted];
        }
    }
    propertyName = kBackgroundColorSelected;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected
                                     appliedProperty:[NUISettings getColor:propertyName withClass:className]];
        if (applyStyle) {
            [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                              forState:UIControlStateSelected];
        }
    }
    propertyName = kBackgroundColorSelectedHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateHighlighted
                                     appliedProperty:[NUISettings getColor:propertyName withClass:className]];
        if (applyStyle) {
            [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                              forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }
    propertyName = kBackgroundColorSelectedDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateDisabled
                                     appliedProperty:[NUISettings getColor:propertyName withClass:className]];
        if (applyStyle) {
            [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                              forState:UIControlStateSelected|UIControlStateDisabled];
        }
    }
    propertyName = kBackgroundColorDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateDisabled
                                     appliedProperty:[NUISettings getColor:propertyName withClass:className]];
        if (applyStyle) {
            [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                              forState:UIControlStateDisabled];
        }
    }
    
    // Set background gradient
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        CAGradientLayer *gradientLayer = [NUIGraphics
                                          gradientLayerWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                          bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                          frame:button.bounds];
        
        BOOL applyStyle = [NUISettings applyProperties:@[kBackgroundColorTop, kBackgroundColorBottom] withClass:className
                                              onObject:button forState:UIControlStateNormal
                                       appliedProperty:gradientLayer];
        if (applyStyle) {
            if (button.gradientLayer) {
                [button.layer replaceSublayer:button.gradientLayer with:gradientLayer];
            } else {
                int backgroundLayerIndex = [button.layer.sublayers count] == 1 ? 0 : 1;
                [button.layer insertSublayer:gradientLayer atIndex:backgroundLayerIndex];
            }
            
            button.gradientLayer = gradientLayer;
        }
    }
    
    // Set background image
    propertyName = kBackgroundImage;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setBackgroundImage:appliedProperty forState:UIControlStateNormal];
        }
    }
    propertyName = kBackgroundImageHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setBackgroundImage:appliedProperty forState:UIControlStateHighlighted];
        }
    }
    propertyName = kBackgroundImageSelected;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setBackgroundImage:appliedProperty forState:UIControlStateSelected];
        }
    }
    propertyName = kBackgroundImageSelectedHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setBackgroundImage:appliedProperty forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }
    propertyName = kBackgroundImageSelectedDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setBackgroundImage:appliedProperty forState:UIControlStateSelected|UIControlStateDisabled];
        }
    }
    propertyName = kBackgroundImageDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setBackgroundImage:appliedProperty forState:UIControlStateDisabled];
        }
    }
    
    // Set image
    propertyName = kImage;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setImage:appliedProperty forState:UIControlStateNormal];
        }
    }
    propertyName = kImageHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setImage:appliedProperty forState:UIControlStateHighlighted];
        }
    }
    propertyName = kImageSelected;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setImage:appliedProperty forState:UIControlStateSelected];
        }
    }
    propertyName = kImageSelectedHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setImage:appliedProperty forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }
    propertyName = kImageSelectedDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setImage:appliedProperty forState:UIControlStateSelected|UIControlStateDisabled];
        }
    }
    propertyName = kImageDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getImage:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setImage:appliedProperty forState:UIControlStateDisabled];
        }
    }
    
    [NUILabelRenderer renderText:button.titleLabel withClass:className];
    
    // Set text align
    propertyName = kTextAlign;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = @([NUISettings getControlContentHorizontalAlignment:propertyName withClass:className]);
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:0
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setContentHorizontalAlignment:[appliedProperty integerValue]];
        }
    }
    
    // Set font color
    propertyName = kFontColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleColor:appliedProperty forState:UIControlStateNormal];
        }
    }
    propertyName = kFontColorHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleColor:appliedProperty forState:UIControlStateHighlighted];
        }
    }
    propertyName = kFontColorSelected;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleColor:appliedProperty forState:UIControlStateSelected];
        }
    }
    propertyName = kFontColorSelectedHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleColor:appliedProperty forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }
    propertyName = kFontColorSelectedDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleColor:appliedProperty forState:UIControlStateSelected|UIControlStateDisabled];
        }
    }
    propertyName = kFontColorDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleColor:appliedProperty forState:UIControlStateDisabled];
        }
    }
    
    // Set text shadow color
    propertyName = kTextShadowColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleShadowColor:appliedProperty forState:UIControlStateNormal];
        }
    }
    propertyName = kTextShadowColorHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleShadowColor:appliedProperty forState:UIControlStateHighlighted];
        }
    }
    propertyName = kTextShadowColorSelected;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleShadowColor:appliedProperty forState:UIControlStateSelected];
        }
    }
    propertyName = kTextShadowColorSelectedHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateHighlighted
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleShadowColor:appliedProperty forState:UIControlStateSelected|UIControlStateHighlighted];
        }
    }
    propertyName = kTextShadowColorSelectedDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateSelected|UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleShadowColor:appliedProperty forState:UIControlStateSelected|UIControlStateDisabled];
        }
    }
    propertyName = kTextShadowColorDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NUISettings getColor:propertyName withClass:className];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:UIControlStateDisabled
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleShadowColor:appliedProperty forState:UIControlStateDisabled];
        }
    }
    
    // title insets
    propertyName = kTitleInsets;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NSValue valueWithUIEdgeInsets:[NUISettings getEdgeInsets:propertyName withClass:className]];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:0
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setTitleEdgeInsets:[appliedProperty UIEdgeInsetsValue]];
        }
    }
    
    // content insets
    propertyName = kContentInsets;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        id appliedProperty = [NSValue valueWithUIEdgeInsets:[NUISettings getEdgeInsets:propertyName withClass:className]];
        BOOL applyStyle = [NUISettings applyProperty:propertyName withClass:className
                                            onObject:button forState:0
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [button setContentEdgeInsets:[appliedProperty UIEdgeInsetsValue]];
        }
    }
    
    [NUIViewRenderer renderBorder:button withClass:className];
    
    // If a shadow-* is configured and corner-radius is set disable mask to bounds and fall back to manually applying corner radius to all sub-views (except the label)
    if ([NUIViewRenderer hasShadowProperties:button withClass:className] &&
        [NUISettings hasProperty:kCornerRadius withClass:className]) {
        CGFloat r = [NUISettings getFloat:kCornerRadius withClass:className];
        for (UIView* subview in button.subviews) {
            if ([subview isKindOfClass:[UILabel class]] == NO) {
                subview.layer.cornerRadius = r;
            }
        }
        button.layer.masksToBounds = NO;
    }
    
    [NUIViewRenderer renderShadow:button withClass:className];
}

// deprecated: not currently used
+ (NSSet *)unrecognizedPropertiesForClass:(NSString *)className {
    //TODO: make this more efficient by making this object a singleton so that this set doesn't need to be reinitialized each time this method is called
    NSArray *propertiesArray = @[kPadding, kBackgroundColor, kBackgroundColorHighlighted,
                                 kBackgroundColorSelected, kBackgroundColorSelectedHighlighted,
                                 kBackgroundColorSelectedDisabled, kBackgroundColorDisabled,
                                 kBackgroundColorTop, kBackgroundColorBottom,
                                 
                                 kBackgroundImage, kBackgroundImageHighlighted, kBackgroundImageSelected,
                                 kBackgroundImageSelectedHighlighted, kBackgroundImageSelectedDisabled,
                                 kBackgroundImageDisabled,
                                 
                                 kImage, kImageHighlighted, kImageSelected, kImageSelectedHighlighted,
                                 kImageSelectedDisabled, kImageDisabled,
                                 
                                 kTextAlign,
                                 
                                 kFontColor, kFontColorHighlighted, kFontColorSelected, kFontColorSelectedHighlighted,
                                 kFontColorSelectedDisabled, kFontColorDisabled,
                                 
                                 kTextShadowColor, kTextShadowColorHighlighted, kTextShadowColorSelected,
                                 kTextShadowColorSelectedHighlighted, kTextShadowColorSelectedDisabled,
                                 kTextShadowColorDisabled,
                                 
                                 kTitleInsets, kContentInsets,
                                 
                                 kCornerRadius];
    NSSet *propertyKeys = [NSSet setWithArray:propertiesArray];
    NSDictionary *dictionary = [NUISettings allPropertiesForClass:className];
    NSSet *receivedKeys = [NSSet setWithArray:[dictionary allKeys]];
    NSMutableSet *unrecognizedProperties = [NSMutableSet setWithCapacity:receivedKeys.count];
    [unrecognizedProperties setSet:receivedKeys];
    [unrecognizedProperties minusSet:propertyKeys];
    return unrecognizedProperties;
}

@end
