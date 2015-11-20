//
//  NUIButtonOverrideTests.m
//  NUIDemo
//
//  Created by Aaron Jubbal on 11/19/15.
//  Copyright © 2015 Tom Benner. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "UIButton+NUI.h"
#import "NUIRenderer.h"
#import "NSObject+NUI.h"
#import "STAButton.h"

static NSString * const NUIButtonBackgroundColorTestsStyleClass = @"ButtonWithColor";

@interface NUIButtonOverrideTests : XCTestCase
@property (strong, nonatomic) STAButton *sut;
@property (strong, nonatomic) NSMutableSet *containersSet;
@end

@implementation NUIButtonOverrideTests

- (void)setUp {
    [super setUp];
    
    [NUISettings initWithStylesheet:@"TestTheme.NUI"];
    
    _sut = [[STAButton alloc] init];
    _sut.nuiClass = NUIButtonBackgroundColorTestsStyleClass;
    
    self.containersSet = [NSMutableSet set];
    __weak typeof(self) weakSelf = self;
    [_sut setRenderOverrideBlock:^BOOL(NUIRenderContainer *container){
         __strong typeof(self) strongSelf = weakSelf;
        
        [strongSelf.containersSet addObject:container];
        if (container.recognizedProperty) {
            // for purposes of this test, overrride background-color to yellow
            if ([container.propertyName isEqualToString:kBackgroundColor]) {
                STAButton *button = container.object;
                [button setBackgroundColor:[UIColor yellowColor] forState:UIControlStateNormal];
                return NO;
            }
            if ([container.propertyName isEqualToString:kBackgroundColorSelected]) {
                STAButton *button = container.object;
                [button setBackgroundColor:[UIColor orangeColor] forState:UIControlStateSelected];
                return NO;
            }
            if ([container.propertyName isEqualToString:kBackgroundColorSelectedHighlighted]) {
                STAButton *button = container.object;
                [button setBackgroundColor:[UIColor purpleColor] forState:UIControlStateDisabled];
                return YES;
            }
        }
        return YES;
    }];
    
    [_sut applyNUI];
}

- (void)tearDown {
    _sut = nil;
    
    [super tearDown];
}

- (void)testOverriddenProperties {
    XCTAssertNil([_sut backgroundImageForState:UIControlStateNormal], @"Background image for state non-nil.");
    XCTAssertEqualObjects([_sut backgroundColorForState:UIControlStateNormal], [UIColor yellowColor], @"Didn't override background color.");
    
    XCTAssertNotNil([_sut backgroundImageForState:UIControlStateDisabled], @"Background image for state nil.");
    XCTAssertNil([_sut backgroundColorForState:UIControlStateHighlighted], @"Background color for state non-nil.");
    
    // ensure that nui didn't attempt to override
    XCTAssertNil([_sut backgroundImageForState:UIControlStateSelected], @"Background image for state non-nil.");
    XCTAssertEqualObjects([_sut backgroundColorForState:UIControlStateSelected], [UIColor orangeColor], @"Didn't override background color.");
    
    XCTAssertNotNil([_sut backgroundImageForState:UIControlStateSelected|UIControlStateHighlighted], @"Background image for state nil.");
    XCTAssertNil([_sut backgroundColorForState:UIControlStateSelected|UIControlStateHighlighted], @"Background color for state non-nil.");
    
    XCTAssertNotNil([_sut backgroundImageForState:UIControlStateSelected|UIControlStateDisabled], @"Background image for state nil.");
    XCTAssertNil([_sut backgroundColorForState:UIControlStateSelected|UIControlStateDisabled], @"Background color for state non-nil.");
    
    // ensure that nui did indeed attempt to override
    XCTAssertNotNil([_sut backgroundImageForState:UIControlStateDisabled], @"Background image for state nil.");
    XCTAssertEqualObjects([_sut backgroundColorForState:UIControlStateDisabled], [UIColor purpleColor], @"Didn't override background color.");
}

- (void)testContainerContents {
    
    NUIRenderContainer *container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = NO;
    container.propertyName = @"unsupported-key";
    container.propertyValue = @"unsupported-value";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateNormal;
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = YES;
    container.propertyName = @"background-color";
    container.propertyValue = @"red";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateNormal;
    container.appliedProperty = [UIColor redColor];
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = YES;
    container.propertyName = @"background-color-highlighted";
    container.propertyValue = @"green";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateHighlighted;
    container.appliedProperty = [UIColor greenColor];
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = YES;
    container.propertyName = @"background-color-selected";
    container.propertyValue = @"green";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateSelected;
    container.appliedProperty = [UIColor greenColor];
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = YES;
    container.propertyName = @"background-color-selected-highlighted";
    container.propertyValue = @"blue";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateSelected|UIControlStateHighlighted;
    container.appliedProperty = [UIColor blueColor];
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = YES;
    container.propertyName = @"background-color-selected-disabled";
    container.propertyValue = @"blue";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateSelected|UIControlStateDisabled;
    container.appliedProperty = [UIColor blueColor];
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    container = [NUIRenderContainer new];
    container.object = _sut;
    container.recognizedProperty = YES;
    container.propertyName = @"background-color-disabled";
    container.propertyValue = @"green";
    container.className = NUIButtonBackgroundColorTestsStyleClass;
    container.state = UIControlStateDisabled;
    container.appliedProperty = [UIColor greenColor];
    
    XCTAssertTrue([self.containersSet containsObject:container], @"Container isn't contained within set.");
    [self.containersSet removeObject:container];
    
    // verify that render override block wasn't called in excess
    XCTAssertTrue(self.containersSet.count == 0, @"Set still contains objects.");
}

@end
