//  Copyright (c) 2015 ODIGEO. All rights reserved.

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUISettings.h"

@interface NUILayerRenderer : NSObject

+ (void)renderLayer:(CALayer *)layerToRender withClass:(NSString *)className;

@end
