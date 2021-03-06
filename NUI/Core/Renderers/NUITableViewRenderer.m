//
//  NUITableViewRenderer.m
//  Pods
//
//  Created by Tobias Heinicke on 19.06.13.
//
//

#import "NUITableViewRenderer.h"

@implementation NUITableViewRenderer

+ (void)render:(UITableView*)tableView withClass:(NSString*)className
{
    [NUISettings checkUnsupportedPropertiesForObject:tableView withClass:className];
    
    // Set seperator style
    if ([NUISettings hasProperty:kSeparatorStyle withClass:className]) {
        [tableView setSeparatorStyle:[NUISettings getSeparatorStyle:kSeparatorStyle withClass:className]];
    }
    
    // Set seperator color
    if ([NUISettings hasProperty:kSeparatorColor withClass:className]) {
        [tableView setSeparatorColor:[NUISettings getColor:kSeparatorColor withClass:className]];
    }

    // Set row height
    if ([NUISettings hasProperty:kRowHeight withClass:className]) {
        [tableView setRowHeight:[NUISettings getFloat:kRowHeight withClass:className]];
    }
    
    [self renderSizeDependentProperties:tableView withClass:(NSString*)className];
}

+ (void)sizeDidChange:(UITableView*)tableView
{
    [self renderSizeDependentProperties:tableView withClass:tableView.nuiClass];
}

+ (void)renderSizeDependentProperties:(UITableView*)tableView withClass:(NSString*)className
{
    // Set background color
    if ([NUISettings hasProperty:kBackgroundColor withClass:className]) {
        [tableView setBackgroundColor:[NUISettings getColor:kBackgroundColor withClass:className]];
    }
    
    // Set background gradient
    if ([NUISettings hasProperty:kBackgroundColorTop withClass:className]) {
        UIImage *gradientImage = [NUIGraphics
                                  gradientImageWithTop:[NUISettings getColor:kBackgroundColorTop withClass:className]
                                  bottom:[NUISettings getColor:kBackgroundColorBottom withClass:className]
                                  frame:tableView.bounds];
        tableView.backgroundView = [[UIImageView alloc] initWithImage:gradientImage];
    }
}

@end

