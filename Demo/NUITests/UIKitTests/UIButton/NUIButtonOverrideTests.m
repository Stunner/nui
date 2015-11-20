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

static NSString * const NUIButtonBackgroundColorTestsStyleClass = @"ButtonWithColor";

@interface NUIButtonOverrideTests : XCTestCase
@property (strong, nonatomic) UIButton *sut;
@property (strong, nonatomic) NSMutableSet *containersSet;
@end

@implementation NUIButtonOverrideTests

- (void)setUp {
    [super setUp];
    
    [NUISettings initWithStylesheet:@"TestTheme.NUI"];
    
    _sut = [[UIButton alloc] init];
    _sut.nuiClass = NUIButtonBackgroundColorTestsStyleClass;
    
    self.containersSet = [NSMutableSet set];
    __weak typeof(self) weakSelf = self;
    [_sut setRenderOverrideBlock:^BOOL(NUIRenderContainer *container){
         __strong typeof(self) strongSelf = weakSelf;
        NSLog(@"render container: %@", container);
        [strongSelf.containersSet addObject:container];
        return YES;
    }];
    
    [_sut applyNUI];
}

- (void)tearDown {
    _sut = nil;
    
    [super tearDown];
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
    
    XCTAssertTrue(self.containersSet.count == 0, @"Set still contains objects.");
}

@end
