//
//  NUIAppearance.m
//  NUI
//
//  Created by Tom Benner on 11/21/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUIAppearance.h"

@implementation NUIAppearance

+ (void)init
{
    [self initUIBarButtonItem];
}

+ (void)initUIBarButtonItem
{
    NSString *className = @"BarButton:BarButtonBack";
    Class uiClass = [UIBarButtonItem class];
    
    NSDictionary *titleTextAttributes = [NUIUtilities titleTextAttributesForClass:className];
    
    if ([[titleTextAttributes allKeys] count] > 0) {
        [[uiClass appearance] setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    
    if ([NUISettings hasProperty:kBackgroundTintColor withClass:className]) {
        [[uiClass appearance] setTintColor:[NUISettings getColor:kBackgroundTintColor withClass:className]];
    }
    
    if ([NUISettings hasProperty:kBackgroundColor withClass:className] ||
               [NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        [[uiClass appearance] setBackButtonBackgroundImage:[NUIGraphics backButtonWithClass:className] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    
    if ([NUISettings hasProperty:kBackgroundImage withClass:className]) {
        [[uiClass appearance] setBackButtonBackgroundImage:[NUISettings getImage:kBackgroundImage withClass:className] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kBackgroundImageSelected withClass:className]) {
        [[uiClass appearance] setBackButtonBackgroundImage:[NUISettings getImage:kBackgroundImageSelected withClass:className] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kBackgroundImageHighlighted withClass:className]) {
        [[uiClass appearance] setBackButtonBackgroundImage:[NUISettings getImage:kBackgroundImageHighlighted withClass:className] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    if ([NUISettings hasProperty:kBackgroundImageDisabled withClass:className]) {
        [[uiClass appearance] setBackButtonBackgroundImage:[NUISettings getImage:kBackgroundImageDisabled withClass:className] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    }
    
}

@end
