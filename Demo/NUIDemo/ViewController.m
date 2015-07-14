//
//  ViewController.m
//  NUIDemo
//
//  Created by Tom Benner on 11/22/12.
//  Copyright (c) 2012 Tom Benner. All rights reserved.
//

#import "ViewController.h"
#import "STAButton.h"
#import "UIButton+NUI.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet STAButton *largeButton;
@property (nonatomic, strong) IBOutlet STAButton *button;
@property (nonatomic, strong) IBOutlet UIButton *smallButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak __typeof__(self) weakSelf = self;
    [self.largeButton setRenderOverrideBlock:^BOOL(id color, UIControlState state) {
        if ([weakSelf.largeButton isKindOfClass:[STAButton class]]) {
            [(STAButton *)weakSelf.largeButton setBackgroundColor:color forState:state];
            return NO;
        }
        return YES;
    }];
    [self.button setRenderOverrideBlock:^BOOL(id color, UIControlState state) {
        if ([weakSelf.button isKindOfClass:[STAButton class]]) {
            [(STAButton *)weakSelf.button setBackgroundColor:color forState:state];
            return NO;
        }
        return YES;
    }];
    [self.smallButton setRenderOverrideBlock:^BOOL(id color, UIControlState state) {
//        if ([weakSelf.smallButton isKindOfClass:[STAButton class]]) {
//            [(STAButton *)weakSelf.smallButton setBackgroundColor:color forState:state];
//            return NO;
//        }
        return YES;
    }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
