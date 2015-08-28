//  Copyright (c) 2015 Odigeo. All rights reserved.

#import "NUIBorderedView.h"
#import "NUICALayer.h"
#import "UIView+NUI.h"
#import "NUISettings.h"

@implementation NUIBorderedView

+ (Class)layerClass {
    
    return [NUICALayer class];
}

@end
