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

@implementation NUIButtonRenderer

+ (void)render:(UIButton*)button withClass:(NSString*)className
{
    NSDictionary *unrecognizedPropertyDictionary = [NUISettings unrecognizedPropertiesForClass:className];
    NSLog(@"unrecognizedProperties: %@", unrecognizedPropertyDictionary);
    if (unrecognizedPropertyDictionary.count > 0 && button.renderOverrideBlock) {
        [NUISettings alertObject:button
                       withClass:className
         ofUnsupportedProperties:unrecognizedPropertyDictionary
                       withBlock:button.renderOverrideBlock];
    }
    
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
    
    // Set background color
    NSString *propertyName = kBackgroundColor;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        [NUIButtonRenderer applyProperty:propertyName withClass:className
                                onButton:button forState:UIControlStateNormal];
    }
    propertyName = kBackgroundColorHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        [NUIButtonRenderer applyProperty:propertyName withClass:className
                                onButton:button forState:UIControlStateHighlighted];
    }
    propertyName = kBackgroundColorSelected;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        [NUIButtonRenderer applyProperty:propertyName withClass:className
                                onButton:button forState:UIControlStateSelected];
    }
    propertyName = kBackgroundColorSelectedHighlighted;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        [NUIButtonRenderer applyProperty:propertyName withClass:className
                                onButton:button forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    propertyName = kBackgroundColorSelectedDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        [NUIButtonRenderer applyProperty:propertyName withClass:className
                                onButton:button forState:UIControlStateSelected|UIControlStateDisabled];
    }
    propertyName = kBackgroundColorDisabled;
    if ([NUISettings hasProperty:propertyName withClass:className]) {
        [NUIButtonRenderer applyProperty:propertyName withClass:className
                                onButton:button forState:UIControlStateDisabled];
    }
    
    // Set background gradient
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        CAGradientLayer *gradientLayer = [NUIGraphics
                                          gradientLayerWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                          bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                          frame:button.bounds];
        
        if (button.gradientLayer) {
            [button.layer replaceSublayer:button.gradientLayer with:gradientLayer];
        } else {
            int backgroundLayerIndex = [button.layer.sublayers count] == 1 ? 0 : 1;
            [button.layer insertSublayer:gradientLayer atIndex:backgroundLayerIndex];
        }
        
        button.gradientLayer = gradientLayer;
    }
    
    // Set background image
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [button setBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:kBackgroundImageHighlighted withClass:className]) {
        [button setBackgroundImage:[NUISettings getImage:kBackgroundImageHighlighted withClass:className] forState:UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kBackgroundImageSelected withClass:className]) {
        [button setBackgroundImage:[NUISettings getImage:kBackgroundImageSelected withClass:className] forState:UIControlStateSelected];
    }
    if ([NUISettings hasProperty:kBackgroundImageSelectedHighlighted withClass:className]) {
        [button setBackgroundImage:[NUISettings getImage:kBackgroundImageSelectedHighlighted withClass:className] forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kBackgroundImageSelectedDisabled withClass:className]) {
        [button setBackgroundImage:[NUISettings getImage:kBackgroundImageSelectedDisabled withClass:className] forState:UIControlStateSelected|UIControlStateDisabled];
    }
    if ([NUISettings hasProperty:kBackgroundImageDisabled withClass:className]) {
        [button setBackgroundImage:[NUISettings getImage:kBackgroundImageDisabled withClass:className] forState:UIControlStateDisabled];
    }
    
    // Set image
    if ([NUISettings hasProperty:kImage withClass:className]) {
        [button setImage:[NUISettings getImage:kImage withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:kImageHighlighted withClass:className]) {
        [button setImage:[NUISettings getImage:kImageHighlighted withClass:className] forState:UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kImageSelected withClass:className]) {
        [button setImage:[NUISettings getImage:kImageSelected withClass:className] forState:UIControlStateSelected];
    }
    if ([NUISettings hasProperty:kImageSelectedHighlighted withClass:className]) {
        [button setImage:[NUISettings getImage:kImageSelectedHighlighted withClass:className] forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kImageSelectedDisabled withClass:className]) {
        [button setImage:[NUISettings getImage:kImageSelectedDisabled withClass:className] forState:UIControlStateSelected|UIControlStateDisabled];
    }
    if ([NUISettings hasProperty:kImageDisabled withClass:className]) {
        [button setImage:[NUISettings getImage:kImageDisabled withClass:className] forState:UIControlStateDisabled];
    }
    
    [NUILabelRenderer renderText:button.titleLabel withClass:className];
    
    // Set text align
    if ([NUISettings hasProperty:kTextAlign withClass:className]) {
        [button setContentHorizontalAlignment:[NUISettings getControlContentHorizontalAlignment:kTextAlign withClass:className]];
    }
    
    // Set font color
    if ([NUISettings hasProperty:kFontColor withClass:className]) {
        [button setTitleColor:[NUISettings getColor:kFontColor withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:kFontColorHighlighted withClass:className]) {
        [button setTitleColor:[NUISettings getColor:kFontColorHighlighted withClass:className] forState:UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kFontColorSelected withClass:className]) {
        [button setTitleColor:[NUISettings getColor:kFontColorSelected withClass:className] forState:UIControlStateSelected];
    }
    if ([NUISettings hasProperty:kFontColorSelectedHighlighted withClass:className]) {
        [button setTitleColor:[NUISettings getColor:kFontColorSelectedHighlighted withClass:className] forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kFontColorSelectedDisabled withClass:className]) {
        [button setTitleColor:[NUISettings getColor:kFontColorSelectedDisabled withClass:className] forState:UIControlStateSelected|UIControlStateDisabled];
    }
    if ([NUISettings hasProperty:kFontColorDisabled withClass:className]) {
        [button setTitleColor:[NUISettings getColor:kFontColorDisabled withClass:className] forState:UIControlStateDisabled];
    }
    
    // Set text shadow color
    if ([NUISettings hasProperty:kTextShadowColor withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:kTextShadowColor withClass:className] forState:UIControlStateNormal];
    }
    if ([NUISettings hasProperty:kTextShadowColorHighlighted withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:kTextShadowColorHighlighted withClass:className] forState:UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kTextShadowColorSelected withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:kTextShadowColorSelected withClass:className] forState:UIControlStateSelected];
    }
    if ([NUISettings hasProperty:kTextShadowColorSelectedHighlighted withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:kTextShadowColorSelectedHighlighted withClass:className] forState:UIControlStateSelected|UIControlStateHighlighted];
    }
    if ([NUISettings hasProperty:kTextShadowColorSelectedDisabled withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:kTextShadowColorSelectedDisabled withClass:className] forState:UIControlStateSelected|UIControlStateDisabled];
    }
    if ([NUISettings hasProperty:kTextShadowColorDisabled withClass:className]) {
        [button setTitleShadowColor:[NUISettings getColor:kTextShadowColorDisabled withClass:className] forState:UIControlStateDisabled];
    }
    
    // title insets
    if ([NUISettings hasProperty:kTitleInsets withClass:className]) {
        [button setTitleEdgeInsets:[NUISettings getEdgeInsets:kTitleInsets withClass:className]];
    }
    
    // content insets
    if ([NUISettings hasProperty:kContentInsets withClass:className]) {
        [button setContentEdgeInsets:[NUISettings getEdgeInsets:kContentInsets withClass:className]];
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

/////////////////////
// PRIVATE METHODS //
/////////////////////

+ (void)applyProperty:(id)propertyName
            withClass:(NSString*)className
             onButton:(UIButton*)button
             forState:(UIControlState)state
{
    BOOL applyStyle = YES;
    if (button.renderOverrideBlock) {
        NUIRenderContainer *container = [NUIRenderContainer new];
        container.recognizedProperty = YES;
        container.object = button;
        container.propertyName = propertyName;
        container.propertyValue = [NUISettings get:propertyName withClass:className];
        container.className = className;
        container.state = state;
        container.appliedProperty = [NUISettings getColor:propertyName withClass:className];
        applyStyle = button.renderOverrideBlock(container);
    }
    if (applyStyle) {
        [button setBackgroundImage:[NUISettings getImageFromColor:propertyName withClass:className]
                          forState:state];
    }
}

@end
