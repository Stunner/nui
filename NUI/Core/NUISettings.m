//
//  NUISettings.m
//  NUI
//
//  Created by Tom Benner on 11/20/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "NUISettings.h"
#import "NUIAppearance.h"
#import "NSObject+NUI.h"
#import "NUIRenderer.h"

@interface NUISettings ()

@property (nonatomic, strong) NSArray *supportedPropertiesArray;

@end

@implementation NUISettings

static NUISettings *instance = nil;

+ (void)init
{
    [self initWithStylesheet:@"NUIStyle"];
}

+ (instancetype)sharedInstance
{
    static NUISettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (NUISettings*)getInstance
{
    return [NUISettings sharedInstance];
}

+ (void)initWithStylesheet:(NSString*)name
{
    instance = [self getInstance];
    [[NUISwizzler new] swizzleAll];
    instance.stylesheetName = name;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    instance.stylesheetOrientation = [self stylesheetOrientationFromInterfaceOrientation:orientation];
    NUIStyleParser *parser = [[NUIStyleParser alloc] init];
    instance.styles = [parser getStylesFromFile:name];
    
    NSArray *array = @[kHeight, kWidth,
                       
                       kVerticalAlign,
                       
                       kBackgroundColor, kBackgroundTintColor, kBackgroundColorHighlighted,
                       kBackgroundColorSelected, kBackgroundColorSelectedHighlighted,
                       kBackgroundColorSelectedDisabled, kBackgroundColorDisabled,
                       kBackgroundColorTop, kBackgroundColorTopSelected, kBackgroundColorBottom,
                       kBackgroundColorBottomSelected, kBackgroundRepeat,
                       
                       kBackgroundImage, kBackgroundImageTop, kBackgroundImageTopLandscape,
                       kBackgroundImageBottom, kBackgroundImageBottomLandscape,
                       kBackgroundImageHighlighted, kBackgroundImageSelected,
                       kBackgroundImageSelectedHighlighted, kBackgroundImageSelectedDisabled,
                       kBackgroundImageDisabled,
                       
                       kBarTintColor,
                       
                       kBorderStyle, kBorderColor, kBorderWidth,
                       
                       kContentInsets, kCornerRadius,
                       
                       kDividerColor, kDividerImage,
                       
                       kExcludeViews, kExcludeSubviews,
                       
                       kFinishedImage, kFinishedImageSelected,
                       
                       kFontColor, kFontColorHighlighted, kFontColorSelected, kFontColorSelectedHighlighted,
                       kFontColorSelectedDisabled, kFontColorDisabled, kFontName, kFontSize,
                       
                       kImage, kImageHighlighted, kImageSelected, kImageSelectedHighlighted,
                       kImageSelectedDisabled, kImageDisabled,
                       
                       kMinimumTrackTintColor, kMaximumTrackTintColor, kMinimumValueImage, kMaximumValueImage,
                       
                       kOffImage, kOnImage,
                       
                       kPadding, kProgressImage, kProgressTintColor,
                       
                       kRowHeight,
                       
                       kScopeBackgroundColor, kScopeBackgroundImage,
                       
                       kSelectedImage, kSelectedImageTintColor,
                       
                       kSeparatorColor, kSeparatorStyle,
                       
                       kShadowColor, kShadowImage, kShadowImageTop, kShadowImageBottom, kShadowRadius,
                       kShadowOffset, kShadowOpacity,
                       
                       kTextAlign, kTextAlpha, kTextAutoFit, kTextOffset, kTextShadowColor,
                       kTextShadowColorHighlighted, kTextShadowColorSelected,
                       kTextShadowColorSelectedHighlighted, kTextShadowColorSelectedDisabled,
                       kTextShadowColorDisabled, kTextShadowOffset, kTextTransform,
                       
                       kTintColor, kOnTintColor, kThumbTintColor, kThumbImage,
                       
                       kTitleInsets, kTitleVerticalOffset,
                       
                       kTrackImage, kTrackTintColor];
    instance.supportedPropertiesArray = array;
    
    [NUIAppearance init];
}

+ (void)appendStylesheet:(NSString *)name
{
    instance = [self getInstance];
    
    if (!instance.additionalStylesheetNames)
        instance.additionalStylesheetNames = [NSMutableArray array];
    
    [instance.additionalStylesheetNames addObject:name];
    NUIStyleParser *parser = [[NUIStyleParser alloc] init];
    [instance appendStyles:[parser getStylesFromFile:name]];
}

- (void)appendStyles:(NSMutableDictionary*)newStyles
{
    for (NSString* key in newStyles) {
        id style = newStyles[key];
        if (![self.styles objectForKey:key]) {
            self.styles[key] = style;
            continue;
        }
    
        for (NSString *propertyKey in style) {
            id propertyValue = style[propertyKey];
            self.styles[key][propertyKey] = propertyValue;
        }
    }
}

+ (void)loadStylesheetByPath:(NSString*)path
{
    instance = [self getInstance];
    NUIStyleParser *parser = [[NUIStyleParser alloc] init];
    instance.styles = [parser getStylesFromPath:path];
}

+ (void)reloadStylesheets
{
    NUIStyleParser *parser = [[NUIStyleParser alloc] init];
    instance.styles = [parser getStylesFromFile:instance.stylesheetName];
    
    if (instance.additionalStylesheetNames) {
        for (NSString *name in instance.additionalStylesheetNames) {
            [instance appendStyles:[parser getStylesFromFile:name]];
        }
    }
}

+ (BOOL)reloadStylesheetsOnOrientationChange:(UIInterfaceOrientation)orientation
{
    instance = [self getInstance];
    NSString *newStylesheetOrientation = [self stylesheetOrientationFromInterfaceOrientation:orientation];
    
    if ([newStylesheetOrientation isEqualToString:instance.stylesheetOrientation])
        return NO;
    
    instance.stylesheetOrientation = newStylesheetOrientation;
    [self reloadStylesheets];
    return YES;
}

+ (BOOL)autoUpdateIsEnabled
{
    instance = [self getInstance];
    return instance.autoUpdatePath != nil;
}

+ (NSString*)autoUpdatePath
{
    instance = [self getInstance];
    return instance.autoUpdatePath;
}

+ (void)setAutoUpdatePath:(NSString*)path
{
    instance = [self getInstance];
    instance.autoUpdatePath = path;
    [NUIRenderer startWatchStyleSheetForChanges];
}

+ (BOOL)hasProperty:(NSString*)property withExplicitClass:(NSString*)className
{
    NSMutableDictionary *ruleSet = [instance.styles objectForKey:className];
    if (ruleSet == nil) {
        return NO;
    }
    if ([ruleSet objectForKey:property] == nil) {
        return NO;
    }
    return YES;
}

+ (BOOL)hasProperty:(NSString*)property withClass:(NSString*)className
{
    NSArray *classes = [self getClasses:className];
    for (NSString *inheritedClass in classes) {
        if ([self hasProperty:property withExplicitClass:inheritedClass]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)hasFontPropertiesWithClass:(NSString*)className
{
    return [self hasProperty:kFontName withClass:className] ||
           [self hasProperty:kFontSize withClass:className];
}

+ (NSDictionary*)allPropertiesForClass:(NSString*)className {
    NSMutableDictionary *ruleSet = nil;
    NSArray *classes = [self getClasses:className];
    for (NSString *inheritedClass in classes) {
        if (!ruleSet) {
            ruleSet = [[NSMutableDictionary alloc] initWithDictionary:[instance.styles objectForKey:inheritedClass]];
        } else {
            [ruleSet addEntriesFromDictionary:[instance.styles objectForKey:inheritedClass]];
        }
    }
    return ruleSet;
}

+ (id)get:(NSString*)property withExplicitClass:(NSString*)className
{
    NSMutableDictionary *ruleSet = [instance.styles objectForKey:className];
    return [ruleSet objectForKey:property];
}

+ (id)get:(NSString*)property withClass:(NSString*)className
{
    NSArray *classes = [self getClasses:className];
    for (NSString *inheritedClass in classes) {
        if ([self hasProperty:property withExplicitClass:inheritedClass]) {
            return [self get:property withExplicitClass:inheritedClass];
        }
    }
    return nil;
}

+ (BOOL)getBoolean:(NSString*)property withClass:(NSString*)className
{   
    return [NUIConverter toBoolean:[self get:property withClass:className]];
}

+ (float)getFloat:(NSString*)property withClass:(NSString*)className
{   
    return [NUIConverter toFloat:[self get:property withClass:className]];
}

+ (CGSize)getSize:(NSString*)property withClass:(NSString*)className
{   
    return [NUIConverter toSize:[self get:property withClass:className]];
}

+ (UIOffset)getOffset:(NSString*)property withClass:(NSString*)className
{   
    return [NUIConverter toOffset:[self get:property withClass:className]];
}

+ (UIEdgeInsets)getEdgeInsets:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toEdgeInsets:[self get:property withClass:className]];
}

+ (UIRectEdge)getRectEdge:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toRectEdge:[self get:property withClass:className]];
}

+ (UIRectCorner)getRectCorner:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toRectCorner:[self get:property withClass:className]];
}

+ (UITextBorderStyle)getBorderStyle:(NSString*)property withClass:(NSString*)className
{   
    return [NUIConverter toBorderStyle:[self get:property withClass:className]];
}

+ (UITableViewCellSeparatorStyle)getSeparatorStyle:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toSeparatorStyle:[self get:property withClass:className]];
}

+ (UIFont*)getFontWithClass:(NSString*)className
{
    return [self getFontWithClass:className baseFont:nil];
}

+ (UIFont*)getFontWithClass:(NSString*)className baseFont:(UIFont *)baseFont
{
    NSString *propertyName;
    CGFloat fontSize;
    UIFont *font = nil;
    
    propertyName = kFontSize;
    
    if ([self hasProperty:propertyName withClass:className]) {
        fontSize = [self getFloat:propertyName withClass:className];
    } else {
        fontSize = baseFont ? baseFont.pointSize : [UIFont systemFontSize];
    }
    
    propertyName = kFontName;
    
    if ([self hasProperty:propertyName withClass:className]) {
        NSString *fontName = [self get:propertyName withClass:className];
        
        if ([[UIFont class] respondsToSelector:@selector(systemFontOfSize:weight:)]) {
            if ([fontName isEqualToString:@"blackSystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightBlack];
            } else if ([fontName isEqualToString:@"heavySystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightHeavy];
            } else if ([fontName isEqualToString:@"lightSystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
            } else if ([fontName isEqualToString:@"mediumSystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
            } else if ([fontName isEqualToString:@"semiboldSystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightSemibold];
            } else if ([fontName isEqualToString:@"thinSystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightThin];
            } else if ([fontName isEqualToString:@"ultraLightSystem"]) {
                font = [UIFont systemFontOfSize:fontSize weight:UIFontWeightUltraLight];
            }
        }
        if (!font) {
            if ([fontName isEqualToString:@"system"]) {
                font = [UIFont systemFontOfSize:fontSize];
            } else if ([fontName isEqualToString:@"boldSystem"]) {
                font = [UIFont boldSystemFontOfSize:fontSize];
            } else if ([fontName isEqualToString:@"italicSystem"]) {
                font = [UIFont italicSystemFontOfSize:fontSize];
            } else {
                font = [UIFont fontWithName:fontName size:fontSize];
            }
        }
    } else {
        font = baseFont ? [baseFont fontWithSize:fontSize] : [UIFont systemFontOfSize:fontSize];
    }
    
    return font;
}

+ (UIColor*)getColor:(NSString*)property withClass:(NSString*)className
{   
    return [NUIConverter toColor:[self get:property withClass:className]];
}

+ (UIColor*)getColorFromImage:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toColorFromImageName:[self get:property withClass:className]];
}

+ (UIImage*)getImageFromColor:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toImageFromColorName:[self get:property withClass:className]];
}

+ (UIImage*)getImage:(NSString*)property withClass:(NSString*)className
{
    UIImage *image = [NUIConverter toImageFromImageName:[self get:property withClass:className]];
    NSString *insetsProperty = [NSString stringWithFormat:@"%@%@", property, @"-insets"];
    if ([self hasProperty:insetsProperty withClass:className]) {
        UIEdgeInsets insets = [self getEdgeInsets:insetsProperty withClass:className];
        image = [image resizableImageWithCapInsets:insets];
    }
    return image;
}

+ (kTextAlignment)getTextAlignment:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toTextAlignment:[self get:property withClass:className]];
}

+ (UIControlContentHorizontalAlignment)getControlContentHorizontalAlignment:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toControlContentHorizontalAlignment:[self get:property withClass:className]];
}

+ (UIControlContentVerticalAlignment)getControlContentVerticalAlignment:(NSString*)property withClass:(NSString*)className
{
    return [NUIConverter toControlContentVerticalAlignment:[self get:property withClass:className]];
}

+ (NSArray*)getClasses:(NSString*)className
{
    NSArray *classes = [[[className componentsSeparatedByString: @":"] reverseObjectEnumerator] allObjects];
    return classes;
}

+ (void)setGlobalExclusions:(NSArray *)array
{
    instance = [self getInstance];
    instance.globalExclusions = [array mutableCopy];
}

+ (NSMutableArray*)getGlobalExclusions
{
    instance = [self getInstance];
    return instance.globalExclusions;
}

+ (NSString *)stylesheetOrientation
{
    instance = [self getInstance];
    return instance.stylesheetOrientation;
}

+ (NSString *)stylesheetOrientationFromInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    return UIInterfaceOrientationIsLandscape(orientation) ? @"landscape" : @"portrait";
}

+ (NSDictionary*)unrecognizedPropertiesForClass:(NSString*)className
{
    NSSet *propertyKeys = [NSSet setWithArray:[self getInstance].supportedPropertiesArray];
    NSDictionary *dictionary = [NUISettings allPropertiesForClass:className];
    NSSet *receivedKeys = [NSSet setWithArray:[dictionary allKeys]];
    NSMutableSet *unrecognizedProperties = [NSMutableSet setWithCapacity:receivedKeys.count];
    [unrecognizedProperties setSet:receivedKeys];
    [unrecognizedProperties minusSet:propertyKeys];
    
    NSMutableDictionary *returnableDictionary = [[NSMutableDictionary alloc] initWithCapacity:unrecognizedProperties.count];
    for (NSString *property in unrecognizedProperties) {
        [returnableDictionary setObject:[dictionary objectForKey:property] forKey:property];
    }
    return returnableDictionary;
}

+ (void)alertObject:(id)object
          withClass:(NSString*)className
ofUnsupportedProperties:(NSDictionary*)properties
          withBlock:(NUIRenderOverrideBlock)block
{
    for (NSString *unrecognizedPropertyKey in [properties allKeys]) {
        NUIRenderContainer *container = [NUIRenderContainer new];
        container.recognizedProperty = NO;
        container.object = object;
        container.propertyName = unrecognizedPropertyKey;
        container.propertyValue = [properties objectForKey:unrecognizedPropertyKey];
        container.className = className;
        block(container);
    }
}

+ (void)checkUnsupportedPropertiesForObject:(NSObject*)object withClass:(NSString*)className {
    NSDictionary *unrecognizedPropertyDictionary = [NUISettings unrecognizedPropertiesForClass:className];
    if (unrecognizedPropertyDictionary.count > 0 && object.renderOverrideBlock) {
        [NUISettings alertObject:object
                       withClass:className
         ofUnsupportedProperties:unrecognizedPropertyDictionary
                       withBlock:object.renderOverrideBlock];
    }
}

+ (BOOL)applyProperties:(NSArray*)propertyNames
              withClass:(NSString*)className
               onObject:(NSObject*)object
               forState:(UIControlState)state
        appliedProperty:(id)appliedProperty
{
    BOOL applyStyle = YES;
    if (object.renderOverrideBlock) {
        NUIRenderContainer *container = [NUIRenderContainer new];
        container.recognizedProperty = YES;
        container.object = object;
        container.propertyName = propertyNames[0];
        container.propertyValue = [NUISettings get:propertyNames[0] withClass:className];
        if (propertyNames.count > 1) {
            container.secondaryPropertyName = propertyNames[1];
            container.secondaryPropertyValue = [NUISettings get:propertyNames[1] withClass:className];
        }
        container.className = className;
        container.state = state;
        container.appliedProperty = appliedProperty;
        applyStyle = object.renderOverrideBlock(container);
    }
    return applyStyle;
}

+ (BOOL)applyProperty:(id)propertyName
            withClass:(NSString*)className
             onObject:(NSObject*)object
             forState:(UIControlState)state
      appliedProperty:(id)appliedProperty
{
    return [NUISettings applyProperties:@[propertyName]
                              withClass:className
                               onObject:object 
                               forState:state
                        appliedProperty:appliedProperty];
}

+ (NSDictionary *)getSpecificStyleWithClass:(NSString *)className {
    
    instance = [self getInstance];
    
    NSArray *specificStyles = [className componentsSeparatedByString:@":"];
    NSMutableDictionary *specificNUIStyleDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *specificStyle in specificStyles) {
        [specificNUIStyleDictionary addEntriesFromDictionary:instance.styles[specificStyle]];
    }
    return specificNUIStyleDictionary;
}

+ (NSDictionary *)getAttributesFromSpecificClass:(NSString *)className {
    NSDictionary *attributes;
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = [NUISettings getSize:kTextShadowOffset withClass:className];
    if ([NUISettings hasProperty:kTextShadowColor withClass:className]) {
        shadow.shadowColor = [NUISettings getColor:kTextShadowColor withClass:className];
    }
    
    attributes =  @{ NSFontAttributeName:[NUISettings getFontWithClass:className],
                     NSForegroundColorAttributeName:[NUISettings getColor:kFontColor withClass:className],
                     NSShadowAttributeName:shadow};
    return attributes;
}

@end
