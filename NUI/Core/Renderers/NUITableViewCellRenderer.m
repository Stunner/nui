//
//  NUITableViewCellRenderer.m
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUITableViewCellRenderer.h"

@implementation NUITableViewCellRenderer

+ (void)render:(UITableViewCell*)cell withClass:(NSString*)className
{
    [self renderSizeDependentProperties:cell];
    
    // Set the labels' background colors to clearColor by default, so they don't show a white
    // background on top of the cell background color
    if (cell.textLabel != nil) {
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        // Set Font
        [NUIRenderer renderLabel:cell.textLabel withClass:className];
    }
    
    if (cell.detailTextLabel != nil) {
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        // Set font
        [NUIRenderer renderLabel:cell.detailTextLabel withClass:className withSuffix:@"Detail"];
    }
    
}

+ (void)sizeDidChange:(UITableViewCell*)cell
{
    [self renderSizeDependentProperties:cell];
}

+ (void)renderSizeDependentProperties:(UITableViewCell*)cell
{
    NSString *className = cell.nuiClass;
    
    // Set background color
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        UIImage *colorImage = [NUISettings getImageFromColor:kBackgroundColor withClass:className];
        cell.backgroundView = [[UIImageView alloc] initWithImage:colorImage];
    }
    
    // Set background gradient
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        UIImage *gradientImage = [NUIGraphics
                                  gradientImageWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                  bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                  frame:cell.bounds];
        cell.backgroundView = [[UIImageView alloc] initWithImage:gradientImage];
    }
    
    // Set selected background color
    if ([NUISettings hasProperty:kBackgroundColorSelected withClass:className]) {
        UIImage *colorImage = [NUISettings getImageFromColor:kBackgroundColorSelected withClass:className];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:colorImage];
    }
    
    // Set selected background gradient
    if ([NUISettings hasProperty:kBackgroundColorTopSelected withClass:className]) {
        UIImage *gradientImage = [NUIGraphics
                                  gradientImageWithTop:[NUISettings getColor:kBackgroundColorTopSelected withClass:className]
                                  bottom:[NUISettings getColor:kBackgroundColorBottomSelected withClass:className]
                                  frame:cell.bounds];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:gradientImage];
    }
}

@end
