//
//  NUIControlRenderer.m
//  NUIDemo
//
//  Created by Alejandro Isaza on 13-01-30.
//  Copyright (c) 2013 Tom Benner. All rights reserved.
//

#import "NUIControlRenderer.h"
#import "NUIViewRenderer.h"

@implementation NUIControlRenderer

+ (void)render:(UIControl*)control withClass:(NSString*)className
{
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [control setBackgroundColor: [NUISettings getColorFromImage:kBackgroundImage withClass: className]];
    } else if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [control setBackgroundColor: [NUISettings getColor:kBackgroundColor withClass: className]];
    }
    
    [NUIViewRenderer renderBorder:control withClass:className];
    [NUIViewRenderer renderShadow:control withClass:className];
}

@end
