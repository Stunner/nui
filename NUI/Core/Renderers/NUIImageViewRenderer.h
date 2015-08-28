//
//  NUIImageViewRenderer.h
//  Pods
//
//  Created by Victor Rodriguez on 14/07/15.
//
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "NUISettings.h"

@interface NUIImageViewRenderer : NSObject

+ (void)renderImageView:(UIImageView*)imageView withClass:(NSString*)className;

@end
