//
//  polygonButton.h
//  polygonButtonDemo
//
//  Created by Chris Personal on 10/16/14.
//  Copyright (c) 2014 Flouu Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface polygonButton : UIButton

+ (polygonButton *)polygonButtonWithFrame:(CGRect)frame withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius pBorderWidth:(CGFloat)lineWidth borderColor:(CGColorRef)pBorderColor;

@end
