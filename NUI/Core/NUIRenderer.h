//
//  NUIRenderer.h
//  NUIDemo
//
//  Created by Tom Benner on 11/24/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NUIConstants.h"
#import "NUIFileMonitor.h"
#import "NUISettings.h"
#import "NUIBarButtonItemRenderer.h"
#import "NUIButtonRenderer.h"
#import "NUIControlRenderer.h"
#import "NUILabelRenderer.h"
#import "NUINavigationBarRenderer.h"
#import "NUINavigationItemRenderer.h"
#import "NUIProgressViewRenderer.h"
#import "NUISearchBarRenderer.h"
#import "NUISegmentedControlRenderer.h"
#import "NUISliderRenderer.h"
#import "NUISwitchRenderer.h"
#import "NUIPageControlRenderer.h"
#import "NUITabBarRenderer.h"
#import "NUITabBarItemRenderer.h"
#import "NUITableViewRenderer.h"
#import "NUITableViewCellRenderer.h"
#import "NUIToolbarRenderer.h"
#import "NUITextFieldRenderer.h"
#import "NUITextViewRenderer.h"
#import "NUIViewRenderer.h"
#import "NUIWindowRenderer.h"
#import "UIView+NUI.h"

@interface NUIRenderer : NSObject

@property(nonatomic)BOOL rerenderOnOrientationChange;

+ (void)rerender;

/**
 *  Allows setting a custom renderer for a nui compatible class or one of its subclasses.
 *  To render a view or item, a renderer is chosen by objectClass.
 *  The one which is the closest ancestor is selected.
 *
 *  For example, a renderer for UIButton takes precedence over one for UIControl.
 *
 *  @param rendererClass The class to render the view. Must provide `+render:withClass:` method.
 *  @param objectClass   The nui compatible class to apply this renderer to.
 */
+ (void)setRenderer:(Class)rendererClass forObjectClass:(Class)objectClass;

+ (void)renderView:(id)view withClass:(NSString*)className;

+ (BOOL)needsTextTransformWithClass:(NSString*)className;
+ (NSString *)transformText:(NSString*)text withClass:(NSString*)className;
+ (NSAttributedString *)transformAttributedText:(NSAttributedString*)text withClass:(NSString*)className;

+ (void)sizeDidChangeForNavigationBar:(UINavigationBar*)bar;
+ (void)sizeDidChangeForTabBar:(UITabBar*)bar;
+ (void)sizeDidChangeForTableView:(UITableView*)tableView;
+ (void)sizeDidChangeForTableViewCell:(UITableViewCell*)cell;

+ (void)addOrientationDidChangeObserver:(id)observer;
+ (void)removeOrientationDidChangeObserver:(id)observer;

+ (void)setRerenderOnOrientationChange:(BOOL)rerender;

@end
