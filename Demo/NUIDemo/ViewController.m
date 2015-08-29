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
#import "NSObject+NUI.h"

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
    
    [self.largeButton setRenderOverrideBlock:^BOOL(NUIRenderContainer *container){
        NSLog(@"render container: %@", container);
        if (container.recognizedProperty && [container.object isKindOfClass:[STAButton class]]) {
            STAButton *button = container.object;
            if ([container.propertyName hasPrefix:@"background-color"]) {
                [button setBackgroundColor:container.appliedProperty forState:container.state];
                return NO;
            }
        }
        return YES;
    }];
    [self.button setRenderOverrideBlock:^BOOL(NUIRenderContainer *container){
        NSLog(@"render container: %@", container);
        if (container.recognizedProperty && [container.object isKindOfClass:[STAButton class]]) {
            STAButton *button = container.object;
            if ([container.propertyName hasPrefix:@"background-color"]) {
                [button setBackgroundColor:container.appliedProperty forState:container.state];
                return NO;
            }
        }
        return YES;
    }];
    [self.smallButton setRenderOverrideBlock:^BOOL(NUIRenderContainer *container){
        NSLog(@"render container: %@", container);
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
