//
//  polygonButton.m
//  polygonButtonDemo
//
//  Created by Chris Personal on 10/16/14.
//  Copyright (c) 2014 Flouu Apps. All rights reserved.
//

#import "polygonButton.h"

@implementation polygonButton


+ (polygonButton *)polygonButtonWithFrame:(CGRect)frame withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius pBorderWidth:(CGFloat)lineWidth borderColor:(CGColorRef)pBorderColor{
    
    polygonButton *button = [[polygonButton alloc] initWithFrame:frame];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.lineWidth = lineWidth;
    borderLayer.strokeColor = pBorderColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.lineJoin = kCALineJoinRound;
    borderLayer.path = maskLayer.path = [button pathForView:button withVertices:vertices initialPointAngle:initialAngle cornerRadius:pCornerRadius lineWidth:lineWidth].CGPath;
    
    button.layer.mask = maskLayer;
    [button.layer addSublayer:borderLayer];
    
    return button;
}

- (UIBezierPath *)pathForView:(UIView *)view withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius lineWidth:(CGFloat)lineWidth{
    
    CGFloat angle = 2*M_PI/vertices;
    
    initialAngle += M_PI;
    
    CGPoint buttonCenter = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    CGFloat totalRadius = view.frame.size.width/2;
    
    CGFloat innerRadius = floor(totalRadius - pCornerRadius);
    
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    
    CGFloat totalAngle = 0*angle + initialAngle;
    CGPoint vertex = CGPointMake(buttonCenter.x + innerRadius*cos(totalAngle), buttonCenter.y + innerRadius*sin(totalAngle));
    
    CGFloat fix = 0;
    CGFloat shiftX = pCornerRadius*cos(totalAngle - (angle/2 - fix));
    CGFloat shiftY = pCornerRadius*sin(totalAngle - (angle/2 - fix));
    CGPoint shiftedVertex = vertex;
    NSLog(@"shifted V: %@", NSStringFromCGPoint(shiftedVertex));
    
    shiftedVertex.x += shiftX;
    shiftedVertex.y += shiftY;
    [bezierPath moveToPoint:shiftedVertex];
    [bezierPath addArcWithCenter:vertex
                          radius:pCornerRadius
                      startAngle:totalAngle - (angle/2 - fix)
                        endAngle:totalAngle + (angle/2 - fix)
                       clockwise:YES];
    
    for (NSInteger i = 1; i < vertices; i++) {
        totalAngle = (double)i*angle + initialAngle;
        shiftX = pCornerRadius*cos(totalAngle - (angle/2 - fix));
        shiftY = pCornerRadius*sin(totalAngle - (angle/2 - fix));
        
        vertex = CGPointMake(buttonCenter.x + innerRadius*cos(totalAngle), buttonCenter.y + innerRadius*sin(totalAngle));
        
        shiftedVertex = vertex;
        shiftedVertex.x += shiftX;
        shiftedVertex.y += shiftY;
        
        [bezierPath addLineToPoint:shiftedVertex];
        [bezierPath addArcWithCenter:vertex
                              radius:pCornerRadius
                          startAngle:totalAngle - (angle/2 - fix)
                            endAngle:totalAngle + (angle/2 - fix)
                           clockwise:YES];
    }
    
    [bezierPath closePath];
    bezierPath.flatness = .3;
    bezierPath.lineWidth = lineWidth;
    return bezierPath;
}

@end
