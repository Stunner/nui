//
//  NUISettings.h
//  NUI
//
//  Created by Tom Benner on 11/20/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NUIConverter.h"
#import "NUIStyleParser.h"
#import "NUISwizzler.h"
#import "NUIRenderContainer.h"

typedef BOOL (^NUIRenderOverrideBlock)(NUIRenderContainer *renderContainer);

//////////////////////////////////////////////////////
//////////////// DEFINED PROPERTIES //////////////////
//////////////////////////////////////////////////////

static NSString * const kHeight = @"height";
static NSString * const kWidth = @"width";

static NSString * const kVerticalAlign = @"vertical-align";

static NSString * const kBackgroundColor = @"background-color";
static NSString * const kBackgroundTintColor = @"background-tint-color";
static NSString * const kBackgroundColorHighlighted = @"background-color-highlighted";
static NSString * const kBackgroundColorSelected = @"background-color-selected";
static NSString * const kBackgroundColorSelectedHighlighted = @"background-color-selected-highlighted";
static NSString * const kBackgroundColorSelectedDisabled = @"background-color-selected-disabled";
static NSString * const kBackgroundColorDisabled = @"background-color-disabled";
static NSString * const kBackgroundColorTop = @"background-color-top";
static NSString * const kBackgroundColorTopSelected = @"background-color-top-selected";
static NSString * const kBackgroundColorBottom = @"background-color-bottom";
static NSString * const kBackgroundColorBottomSelected = @"background-color-bottom-selected";
static NSString * const kBackgroundRepeat = @"background-repeat";

static NSString * const kBackgroundImage = @"background-image";
static NSString * const kBackgroundImageTop = @"background-image-top";
static NSString * const kBackgroundImageTopLandscape = @"background-image-top-landscape";
static NSString * const kBackgroundImageBottom = @"background-image-bottom";
static NSString * const kBackgroundImageBottomLandscape = @"background-image-bottom-landscape";
static NSString * const kBackgroundImageHighlighted = @"background-image-highlighted";
static NSString * const kBackgroundImageSelected = @"background-image-selected";
static NSString * const kBackgroundImageSelectedHighlighted = @"background-image-selected-highlighted";
static NSString * const kBackgroundImageSelectedDisabled = @"background-image-selected-disabled";
static NSString * const kBackgroundImageDisabled = @"background-image-disabled";

static NSString * const kBarTintColor = @"bar-tint-color";

static NSString * const kBorderStyle = @"border-style";
static NSString * const kBorderColor = @"border-color";
static NSString * const kBorderWidth = @"border-width";

static NSString * const kContentInsets = @"content-insets";
static NSString * const kCornerRadius = @"corner-radius";

static NSString * const kDividerColor = @"divider-color";
static NSString * const kDividerImage = @"divider-image";

static NSString * const kExcludeViews = @"exclude-views";
static NSString * const kExcludeSubviews = @"exclude-subviews";

static NSString * const kFinishedImage = @"finished-image";
static NSString * const kFinishedImageSelected = @"finished-image-selected";

static NSString * const kFontColor = @"font-color";
static NSString * const kFontColorHighlighted = @"font-color-highlighted";
static NSString * const kFontColorSelected = @"font-color-selected";
static NSString * const kFontColorSelectedHighlighted = @"font-color-selected-highlighted";
static NSString * const kFontColorSelectedDisabled = @"font-color-selected-disabled";
static NSString * const kFontColorDisabled = @"font-color-disabled";
static NSString * const kFontName = @"font-name";
static NSString * const kFontSize = @"font-size";

static NSString * const kImage = @"image";
static NSString * const kImageHighlighted = @"image-highlighted";
static NSString * const kImageSelected = @"image-selected";
static NSString * const kImageSelectedHighlighted = @"image-selected-highlighted";
static NSString * const kImageSelectedDisabled = @"image-selected-disabled";
static NSString * const kImageDisabled = @"image-disabled";

static NSString * const kMinimumTrackTintColor = @"minimum-track-tint-color";
static NSString * const kMaximumTrackTintColor = @"maximum-track-tint-color";
static NSString * const kMinimumValueImage = @"minimum-value-image";
static NSString * const kMaximumValueImage = @"maximum-value-image";

static NSString * const kOffImage = @"off-image";
static NSString * const kOnImage = @"on-image";

static NSString * const kPadding = @"padding";
static NSString * const kProgressImage = @"progress-image";
static NSString * const kProgressTintColor = @"progress-tint-color";

static NSString * const kRowHeight = @"row-height";

static NSString * const kScopeBackgroundColor = @"scope-background-color";
static NSString * const kScopeBackgroundImage = @"scope-background-image";

static NSString * const kSelectedImage = @"selected-image";
static NSString * const kSelectedImageTintColor = @"selected-image-tint-color";

static NSString * const kSeparatorColor = @"separator-color";
static NSString * const kSeparatorStyle = @"separator-style";

static NSString * const kShadowColor = @"shadow-color";
static NSString * const kShadowImage = @"shadow-image";
static NSString * const kShadowImageTop = @"shadow-image-top";
static NSString * const kShadowImageBottom = @"shadow-image-bottom";
static NSString * const kShadowRadius = @"shadow-radius";
static NSString * const kShadowOffset = @"shadow-offset";
static NSString * const kShadowOpacity = @"shadow-opacity";

static NSString * const kTextAlign = @"text-align";
static NSString * const kTextAlpha = @"text-alpha";
static NSString * const kTextAutoFit = @"text-auto-fit";
static NSString * const kTextOffset = @"text-offset";
static NSString * const kTextShadowColor = @"text-shadow-color";
static NSString * const kTextShadowColorHighlighted = @"text-shadow-color-highlighted";
static NSString * const kTextShadowColorSelected = @"text-shadow-color-selected";
static NSString * const kTextShadowColorSelectedHighlighted = @"text-shadow-color-selected-highlighted";
static NSString * const kTextShadowColorSelectedDisabled = @"text-shadow-color-selected-disabled";
static NSString * const kTextShadowColorDisabled = @"text-shadow-color-disabled";
static NSString * const kTextShadowOffset = @"text-shadow-offset";
static NSString * const kTextTransform = @"text-transform";

static NSString * const kTintColor = @"tint-color";
static NSString * const kOnTintColor = @"on-tint-color";
static NSString * const kThumbTintColor = @"thumb-tint-color";
static NSString * const kThumbImage = @"thumb-image";

static NSString * const kTitleInsets = @"title-insets";
static NSString * const kTitleVerticalOffset = @"title-vertical-offset";

static NSString * const kTrackImage = @"track-image";
static NSString * const kTrackTintColor = @"track-tint-color";

//////////////////////////////////////////////////////

@interface NUISettings : NSObject {
    NSString *autoUpdatePath;
    NSMutableDictionary *styles;
    NSString *stylesheetName;
    NSMutableArray *additionalStylesheetNames;
    NSString *stylesheetOrientation;
}

@property(nonatomic,retain)NSString *autoUpdatePath;
@property(nonatomic,retain)NSMutableDictionary *styles;
@property(nonatomic,retain)NSString *stylesheetName;
@property(nonatomic,retain)NSMutableArray *additionalStylesheetNames;
@property(nonatomic,retain)NSMutableArray *globalExclusions;
@property(nonatomic,retain)NSString* stylesheetOrientation;

+ (void)init;
+ (void)initWithStylesheet:(NSString*)name;
+ (void)appendStylesheet:(NSString*)name;
+ (void)loadStylesheetByPath:(NSString*)path;
+ (BOOL)reloadStylesheetsOnOrientationChange:(UIInterfaceOrientation)orientation;
+ (BOOL)autoUpdateIsEnabled;
+ (NSString*)autoUpdatePath;
+ (void)setAutoUpdatePath:(NSString*)path;
+ (BOOL)hasProperty:(NSString*)property withClass:(NSString*)className;
+ (BOOL)hasFontPropertiesWithClass:(NSString*)className;
+ (NSDictionary*)allPropertiesForClass:(NSString*)className;
+ (id)get:(NSString*)property withClass:(NSString*)className;
+ (BOOL)getBoolean:(NSString*)property withClass:(NSString*)className;
+ (float)getFloat:(NSString*)property withClass:(NSString*)className;
+ (CGSize)getSize:(NSString*)property withClass:(NSString*)className;
+ (UIOffset)getOffset:(NSString*)property withClass:(NSString*)className;
+ (UIEdgeInsets)getEdgeInsets:(NSString*)property withClass:(NSString*)className;
+ (UITextBorderStyle)getBorderStyle:(NSString*)property withClass:(NSString*)className;
+ (UITableViewCellSeparatorStyle)getSeparatorStyle:(NSString*)property withClass:(NSString*)className;
+ (UIFont*)getFontWithClass:(NSString*)className;
+ (UIFont*)getFontWithClass:(NSString*)className baseFont:(UIFont *)baseFont;
+ (UIColor*)getColor:(NSString*)property withClass:(NSString*)className;
+ (UIColor*)getColorFromImage:(NSString*)property withClass:(NSString*)className;
+ (UIImage*)getImage:(NSString*)property withClass:(NSString*)className;
+ (UIImage*)getImageFromColor:(NSString*)property withClass:(NSString*)className;
+ (kTextAlignment)getTextAlignment:(NSString*)property withClass:(NSString*)className;
+ (UIControlContentHorizontalAlignment)getControlContentHorizontalAlignment:(NSString*)property withClass:(NSString*)className;
+ (UIControlContentVerticalAlignment)getControlContentVerticalAlignment:(NSString*)property withClass:(NSString*)className;
+ (NSMutableArray*)getGlobalExclusions;
+ (void)setGlobalExclusions:(NSArray*)globalExclusions;
+ (NSString *)stylesheetOrientation;

+ (NSDictionary*)unrecognizedPropertiesForClass:(NSString*)className;
+ (void)alertObject:(id)object
          withClass:(NSString*)className
ofUnsupportedProperties:(NSDictionary*)properties
          withBlock:(NUIRenderOverrideBlock)block;
+ (void)checkUnsupportedPropertiesForObject:(NSObject*)object
                                  withClass:(NSString*)className;

@end

