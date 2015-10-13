//
//  NUITextFieldRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITextFieldRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUITextFieldRenderer

+ (void)render:(UITextField*)textField withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:textField withClass:className];
    
    if ([NUISettings hasFontPropertiesWithClass:className]) {
        id appliedProperty = [NUISettings getFontWithClass:className baseFont:textField.font];
        BOOL applyStyle = [NUISettings applyProperties:@[kFontName, kFontSize] withClass:className
                                            onObject:textField forState:UIControlStateNormal
                                     appliedProperty:appliedProperty];
        if (applyStyle) {
            [textField setFont:[NUISettings getFontWithClass:className baseFont:textField.font]];
        }
    }
    
    // Set font color
    if ([NUISettings hasProperty:kFontColor withClass:className]) {
        [textField setTextColor:[NUISettings getColor:kFontColor withClass:className]];
    }
    
    // Set background color
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [textField setBackgroundColor:[NUISettings getColor:kBackgroundColor withClass:className]];
    }
    
    // Set background gradient
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        // TODO: investigate if null background color bottom property could cause issues
        UIImage *gradient = [NUIGraphics
                             gradientImageWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                             bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                             frame:textField.bounds];
        [textField setBackground:gradient];
    }
    
    // Set background image
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [textField setBackground:[NUISettings getImage:kBackgroundImage withClass:className]];
    }
    
    if ([NUISettings hasProperty:kVerticalAlign withClass:className]) {
        [textField setContentVerticalAlignment:[NUISettings getControlContentVerticalAlignment:kVerticalAlign withClass:className]];
    }

    // Set border style
    if ([NUISettings hasProperty:kBorderStyle withClass:className]) {
        [textField setBorderStyle:[NUISettings getBorderStyle:kBorderStyle withClass:className]];
    }

    [NUIViewRenderer renderSize:textField withClass:className];
    [NUIViewRenderer renderBorderAndCorner:textField withClass:className];
    [NUIViewRenderer renderShadow:textField withClass:className];
}

@end
