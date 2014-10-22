//
//  UIButton+polygonButton.m
//  polygonButtonDemo
//
//  Created by Chris Personal on 10/22/14.
//  Copyright (c) 2014 Flouu Apps. All rights reserved.
//
//  inspired by "thinking like a bezier path" http://ronnqvi.st/thinking-like-a-bzier-path/


#import "UIButton+polygonButton.h"

@implementation UIButton (polygonButton)

- (void)setUpPolygonForButton:(UIView *)button withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius pBorderWidth:(CGFloat)lineWidth borderColor:(CGColorRef)pBorderColor {
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.lineWidth = lineWidth;
    borderLayer.strokeColor = pBorderColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.lineJoin = kCALineJoinRound;
    borderLayer.path = maskLayer.path = [self pathForView:button withVertices:vertices initialPointAngle:initialAngle cornerRadius:pCornerRadius lineWidth:lineWidth].CGPath;
    
    button.layer.mask = maskLayer;
    [button.layer addSublayer:borderLayer];
}

- (UIBezierPath *)pathForView:(UIView *)view withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius lineWidth:(CGFloat)lineWidth {

    CGFloat angle = 2*M_PI/vertices;
    initialAngle += M_PI;
    
    CGPoint buttonCenter = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    CGFloat totalRadius = view.frame.size.width/2;
    
    CGFloat innerRadius = floor(totalRadius - pCornerRadius);
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    
    CGFloat totalAngle = 0*angle + initialAngle;
    CGPoint vertex = CGPointMake(buttonCenter.x + innerRadius*cos(totalAngle), buttonCenter.y + innerRadius*sin(totalAngle));
    
    CGFloat shiftX = pCornerRadius*cos(totalAngle - angle/2);
    CGFloat shiftY = pCornerRadius*sin(totalAngle - angle/2);
    CGPoint shiftedVertex = vertex;
    
    shiftedVertex.x += shiftX;
    shiftedVertex.y += shiftY;
    [bezierPath moveToPoint:shiftedVertex];
    [bezierPath addArcWithCenter:vertex
                          radius:pCornerRadius
                      startAngle:totalAngle - angle/2
                        endAngle:totalAngle + angle/2
                       clockwise:YES];
    
    for (NSInteger i = 1; i < vertices; i++) {
        totalAngle = (double)i*angle + initialAngle;
        shiftX = pCornerRadius*cos(totalAngle - angle/2);
        shiftY = pCornerRadius*sin(totalAngle - angle/2);
        
        vertex = CGPointMake(buttonCenter.x + innerRadius*cos(totalAngle), buttonCenter.y + innerRadius*sin(totalAngle));
        
        shiftedVertex = vertex;
        shiftedVertex.x += shiftX;
        shiftedVertex.y += shiftY;
        
        [bezierPath addLineToPoint:shiftedVertex];
        [bezierPath addArcWithCenter:vertex
                              radius:pCornerRadius
                          startAngle:totalAngle - angle/2
                            endAngle:totalAngle + angle/2
                           clockwise:YES];
    }
    
    [bezierPath closePath];
    bezierPath.flatness = .3;
    bezierPath.lineWidth = lineWidth;
    return bezierPath;
}

+ (NSArray *)evenlySpacedGoldenRatioButtonsWith:(NSInteger)numberOfButtons width:(CGFloat)spaceWidth yPos:(CGFloat)spaceHeight  {
    //this gives position in purely frame Math way
    //an autolayout method should be made -- trying to think how I want to implement that -- method that takes view and buttons -- block?
    
    CGFloat buttonWidth = spaceWidth/(1.303*(CGFloat)numberOfButtons + 0.3083);
    CGFloat buttonSpacing = 0.3083*buttonWidth;
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (NSInteger i = 0; i < numberOfButtons; i++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = floor(buttonSpacing + (CGFloat)i*(buttonSpacing + buttonWidth));
        aButton.frame = CGRectMake(x, spaceHeight, buttonWidth, buttonWidth);
        
        //  Basic Default Colors
        aButton.backgroundColor = [UIColor darkGrayColor];
        [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [aButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:.65] forState:UIControlStateHighlighted];
        
        [buttons addObject:aButton];
    }
    return [NSArray arrayWithArray:buttons];
}

@end
