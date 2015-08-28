//
//  UIImageView+NUI.m
//  Pods
//
//  Created by Victor Rodriguez on 14/07/15.
//
//

#import "UIImageView+NUI.h"

@implementation UIImageView (NUI)

- (void)initNUI
{
    if (!self.nuiClass) {
        self.nuiClass = @"ImageView";
    }
}

- (void)applyNUI
{
    if ([self isMemberOfClass:[UIImageView class]] || self.nuiClass) {
        [self initNUI];
        if (![self.nuiClass isEqualToString:kNUIClassNone]) {
            [NUIRenderer renderImageView:self withClass:self.nuiClass];
        }
    }
    self.nuiApplied = YES;
}

- (void)override_didMoveToWindow
{
    if (!self.isNUIApplied) {
        [self applyNUI];
    }
    [self override_didMoveToWindow];
}

@end
