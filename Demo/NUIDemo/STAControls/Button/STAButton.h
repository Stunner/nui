//
//  STAButton.h
//  STAControls
//
//  Created by Aaron Jubbal on 5/18/15.
//  Copyright (c) 2015 Aaron Jubbal. All rights reserved.
//

// taken from: https://github.com/Stunner/STAControls

#import <UIKit/UIKit.h>

@interface STAButton : UIButton

typedef void (^ StateChangeBlock)(UIControlState, UIControlState);

- (void)setBackgroundColor:(UIColor *)backgroundColor
                  forState:(UIControlState)state;

-(void)registerForStateChangesWithBlock:(StateChangeBlock)block;

@end
