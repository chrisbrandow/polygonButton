//
//  UIButton+polygonButton.h
//  polygonButtonDemo
//
//  Created by Chris Personal on 10/22/14.
//  Copyright (c) 2014 Flouu Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (polygonButton)

- (void)setUpPolygonForButton:(UIView *)button withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius pBorderWidth:(CGFloat)lineWidth borderColor:(CGColorRef)pBorderColor;

+ (NSArray *)evenlySpacedGoldenRatioButtonsWith:(NSInteger)numberOfButtons width:(CGFloat)spaceWidth yPos:(CGFloat)spaceHeight;

@end
