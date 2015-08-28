//  Copyright (c) 2015 ODIGEO. All rights reserved.

#import "NUICALayer.h"

@interface NUICALayer ()

@property(nonatomic, strong) CAShapeLayer *viewShapeLayer;
@property(nonatomic, strong) CAShapeLayer *borderLayer;
@property(nonatomic, strong) CAShapeLayer *contentLayer;

@property(nonatomic, assign) CGRect lastBounds;

@end

@implementation NUICALayer

#pragma mark - Initialization

- (id)init {
    
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

// FIXME: We should try to reduce of calls to 'updatePaths'.
- (void)commonInit {
    
    _lastBounds = CGRectIntegral(self.bounds);

    _customBorderWidth = 0.5;
    _customCornerRadius = 0;
    _bottomLeftOffset = 0;
    _cornerRect = 0;
    _borderRect = 0;
    
    [self updatePaths];
    [self updateColors];
    
    [self setMasksToBounds:YES];
}

- (void)reset {
    
    [self commonInit];
}

#pragma mark - Custom setters and getters

- (void)setBottomLeftOffset:(CGFloat)bottomLeftOffset {
    _bottomLeftOffset = bottomLeftOffset;
    [self updatePaths];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    
    _customBorderWidth = borderWidth;
    [self updatePaths];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    _customCornerRadius = cornerRadius;
    [self updatePaths];
}

- (void)setCornerRect:(UIRectCorner)cornerRect {
    
    _cornerRect = cornerRect;
    if (self.customCornerRadius > 0.0) {
        [self updatePaths];
    }
}

- (void)setBorderRect:(UIRectEdge)borderRect {
    
    _borderRect = borderRect;
    if (self.customBorderWidth > 0.0) {
        if (_borderRect == 0) {
            _customBorderWidth = 0.0;
        }
        [self updatePaths];
    }
}

- (void)setCustomBackgroundColor:(UIColor *)customBackgroundColor {
    
    _customBackgroundColor = customBackgroundColor;
    [self updateBackgroundColor];
}

- (void)setCustomBorderColor:(UIColor *)customBorderColor {
    
    _customBorderColor = customBorderColor;
    [self updateBorderColor];
}

- (CAShapeLayer *)borderLayer {
    
    if (!_borderLayer) {
        _borderLayer = [[CAShapeLayer alloc] init];
        [self addSublayer:_borderLayer];
        _borderLayer.fillColor = nil;
    }
    
    return _borderLayer;
}

- (CAShapeLayer *)viewShapeLayer {
    
    if (!_viewShapeLayer) {
        _viewShapeLayer = [[CAShapeLayer alloc] init];
        _viewShapeLayer.fillColor = [UIColor whiteColor].CGColor;
        self.mask = _viewShapeLayer;
    }
    
    return _viewShapeLayer;
}

- (CAShapeLayer *)contentLayer {
    
    if (!_contentLayer) {
        _contentLayer = [[CAShapeLayer alloc] init];
        [self addSublayer:_contentLayer];
        _contentLayer.fillColor = nil;
    }
    
    return _contentLayer;
}

#pragma mark - Update layer

- (void)layoutSublayers {
    
    [super layoutSublayers];
    
    [self shouldUpdateSublayers];
}

- (void)shouldUpdateSublayers {
    
    CGRect newBounds = CGRectIntegral(self.bounds) ;
    
    if (!CGRectEqualToRect(self.lastBounds, newBounds)) {
        self.lastBounds = newBounds;
        [self updatePaths];
    }
    
    self.borderLayer.zPosition = self.sublayers.count;
    self.contentLayer.zPosition = -1.0;
}

- (void)updatePaths {
    
    UIBezierPath *viewShapePath = [self calculateViewShapePath];
    UIBezierPath *borderPath = [self calculateBorderPath];
    
    self.borderLayer.frame = self.lastBounds;
    self.borderLayer.path = borderPath.CGPath;
    self.borderLayer.lineWidth = self.customBorderWidth;
    
    self.contentLayer.frame = self.lastBounds;
    self.contentLayer.path = viewShapePath.CGPath;
    
    self.viewShapeLayer.frame = self.lastBounds;
    self.viewShapeLayer.path = viewShapePath.CGPath;
}

- (void)updateColors {
    
    [self updateBackgroundColor];
    [self updateBorderColor];
}

- (void)updateBackgroundColor {
    
    self.contentLayer.fillColor = self.customBackgroundColor.CGColor;
}

- (void)updateBorderColor {
    
    self.borderLayer.strokeColor = self.customBorderColor.CGColor;
}

#pragma mark - Paths calculations

- (UIBezierPath *)calculateViewShapePath {
    
    return [UIBezierPath bezierPathWithRoundedRect:self.lastBounds
                                 byRoundingCorners:self.cornerRect
                                       cornerRadii:CGSizeMake(self.customCornerRadius, self.customCornerRadius)];
}

- (UIBezierPath *)calculateBorderPath {
    
    if (CGRectGetHeight(self.lastBounds) == 0 || CGRectGetWidth(self.lastBounds) == 0) {
        return nil;
    }
    
    UIBezierPath *path;
    CGFloat realRadius = fabs(self.customBorderWidth / 2 - self.customCornerRadius);
    
    if ((self.borderRect == UIRectEdgeAll && self.bottomLeftOffset == 0) || self.borderRect == 0) {
        path = [self calculateViewShapePath];
    } else {
        path = [[UIBezierPath alloc] init];
        if (self.borderRect & UIRectEdgeTop) {
            CGPoint startPoint = [self topStartPoint];
            CGPoint endPoint = [self topEndPoint];
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            
            if ((self.cornerRect & UIRectCornerTopRight) && (self.borderRect & UIRectEdgeRight)) {
                CGPoint centerPoint = CGPointMake(endPoint.x, [self rightStartPoint].y);
                [path addArcWithCenter:centerPoint radius:realRadius startAngle:3 * M_PI_2 endAngle:0 clockwise:YES];
            }
            
        }
        if (self.borderRect & UIRectEdgeRight) {
            CGPoint startPoint = [self rightStartPoint];
            CGPoint endPoint = [self rightEndPoint];
            
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            
            if ((self.cornerRect & UIRectCornerBottomRight) && (self.borderRect & UIRectEdgeBottom)) {
                CGPoint centerPoint = CGPointMake([self bottomEndPoint].x, endPoint.y);
                [path addArcWithCenter:centerPoint radius:realRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            }
        }
        if (self.borderRect & UIRectEdgeBottom) {
            CGPoint startPoint = [self bottomStartPoint];
            CGPoint endPoint = [self bottomEndPoint];
            
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            
            if ((self.cornerRect & UIRectCornerBottomLeft) && self.bottomLeftOffset == 0 && (self.borderRect & UIRectEdgeLeft)) {
                CGPoint centerPoint = CGPointMake(startPoint.x, [self leftEndPoint].y);
                [path addArcWithCenter:centerPoint radius:realRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            }
        }
        if (self.borderRect & UIRectEdgeLeft) {
            CGPoint startPoint = [self leftStartPoint];
            CGPoint endPoint = [self leftEndPoint];
            
            [path moveToPoint:startPoint];
            [path addLineToPoint:endPoint];
            
            if ((self.cornerRect & UIRectCornerTopLeft) && (self.borderRect & UIRectEdgeTop)) {
                CGPoint centerPoint = CGPointMake([self topStartPoint].x, startPoint.y);
                [path addArcWithCenter:centerPoint radius:realRadius startAngle:M_PI endAngle:3 * M_PI_2 clockwise:YES];
            }
        }
    }
    
    return path;
}

#pragma mark - Corner width calculations

- (CGFloat)widthForCorner:(UIRectCorner)corner {
    
    return (self.cornerRect & corner) && (self.customCornerRadius > 0) ? MAX(self.customCornerRadius, self.customBorderWidth/2) : self.customBorderWidth/2;
}

- (CGPoint)topStartPoint {
    
    CGFloat leftOffset = [self widthForCorner:UIRectCornerTopLeft];
    
    return CGPointMake(leftOffset, self.customBorderWidth / 2);
}

- (CGPoint)topEndPoint {
    
    CGFloat rightOffset = [self widthForCorner:UIRectCornerTopRight];
    
    return CGPointMake(CGRectGetMaxX(self.bounds) - rightOffset, self.customBorderWidth / 2);
}

- (CGPoint)rightStartPoint {
    
    CGFloat topOffset = [self widthForCorner:UIRectCornerTopRight];
    
    return CGPointMake(CGRectGetMaxX(self.bounds) - self.customBorderWidth / 2, topOffset);
}

- (CGPoint)rightEndPoint {
    
    CGFloat bottomOffset = [self widthForCorner:UIRectCornerBottomRight];
    
    return CGPointMake(CGRectGetMaxX(self.bounds) - self.customBorderWidth / 2, CGRectGetMaxY(self.bounds) - bottomOffset);
}

- (CGPoint)bottomStartPoint {
    
    CGFloat leftOffset = [self widthForCorner:UIRectCornerBottomLeft];
    
    leftOffset = MAX(self.bottomLeftOffset, leftOffset);
    
    return CGPointMake(leftOffset, CGRectGetMaxY(self.bounds) - self.customBorderWidth / 2);
}

- (CGPoint)bottomEndPoint {
    
    CGFloat rightOffset = [self widthForCorner:UIRectCornerBottomRight];
    
    return CGPointMake(CGRectGetMaxX(self.bounds) - rightOffset, CGRectGetMaxY(self.bounds) - self.customBorderWidth / 2);
}

- (CGPoint)leftStartPoint {
    
    CGFloat topOffset = [self widthForCorner:UIRectCornerTopLeft];
    
    return CGPointMake(self.customBorderWidth / 2, topOffset);
}

- (CGPoint)leftEndPoint {
    
    CGFloat bottomOffset = [self widthForCorner:UIRectCornerBottomLeft];
    
    return CGPointMake(self.customBorderWidth / 2, CGRectGetMaxY(self.bounds) - bottomOffset);
}

@end
