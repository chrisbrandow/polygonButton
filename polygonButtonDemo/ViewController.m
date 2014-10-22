//
//  ViewController.m
//  polygonButtonDemo
//
//  Created by Chris Personal on 10/15/14.
//  Copyright (c) 2014 Flouu Apps. All rights reserved.
//

#import "ViewController.h"
#import "polygonButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *buttons = [self evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:200];
    NSArray *buttons2 = [self evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:500];
    NSArray *buttons3 = [self evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:400];
    NSArray *buttons4 = [self evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:300];

    [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        [b setTitle:[NSString stringWithFormat:@"%zd", idx+1] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        b.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:(2+(CGFloat)idx)/6];
        b.layer.zPosition = -10;
        [self setUpPolygonForButton:b withVertices:3+idx initialPointAngle:M_PI_2 cornerRadius:3 pBorderWidth:4 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.6 brightness:.8 alpha:1].CGColor];
        
        [self.view addSubview:b];
    }];
    
    [buttons4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        [b setTitle:[NSString stringWithFormat:@"%zd", idx+1] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        b.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:(2+(CGFloat)idx)/6];
        b.layer.zPosition = -10;
        [self setUpPolygonForButton:b withVertices:5 initialPointAngle:M_PI_2 cornerRadius:3 pBorderWidth:2*(CGFloat)idx borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.6 brightness:.8 alpha:1].CGColor];
        
        [self.view addSubview:b];
    }];
    
    [buttons3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        [b setTitle:[NSString stringWithFormat:@"%zd", idx+1] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        b.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:(2+(CGFloat)idx)/6];
        b.layer.zPosition = -10;
        [self setUpPolygonForButton:b withVertices:4 initialPointAngle:M_PI_2 cornerRadius:(CGFloat)idx*5.0 pBorderWidth:16 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.6 brightness:.8 alpha:1].CGColor];
        
        [self.view addSubview:b];
    }];
    
    [buttons2 enumerateObjectsUsingBlock:^(UIButton *b, NSUInteger idx, BOOL *stop) {
//        UIButton *b = obj;
        [b setTitle:[NSString stringWithFormat:@"%zd", idx+1] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        b.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:(2+(CGFloat)idx)/6];
        b.layer.zPosition = -10;
        [self setUpPolygonForButton:b withVertices:4 initialPointAngle:M_PI_4 cornerRadius:(CGFloat)idx*5.0 pBorderWidth:16 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.6 brightness:.8 alpha:1].CGColor];

        b.layer.cornerRadius = b.layer.bounds.size.width/2;
        [self.view addSubview:b];
    }];
}

- (void)buttonAction:(id)sender {
    NSLog(@"you pushed button: %@", [[sender titleLabel] text]);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)evenlySpacedGoldenRatioButtonsWith:(NSInteger)numberOfButtons width:(CGFloat)spaceWidth yPos:(CGFloat)spaceHeight  {
    //this gives position in purely frame Math way
    //an autolayout method should be made
    CGFloat buttonWidth = spaceWidth/(1.303*(CGFloat)numberOfButtons + 0.3083);
    CGFloat buttonSpacing = 0.3083*buttonWidth;
    
    NSMutableArray *buttons = [NSMutableArray new];
    
    for (NSInteger i = 0; i < numberOfButtons; i++) {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = floor(buttonSpacing + (CGFloat)i*(buttonSpacing + buttonWidth));
        aButton.frame = CGRectMake(x, spaceHeight, buttonWidth, buttonWidth);
        aButton.backgroundColor = [UIColor redColor];
        [buttons addObject:aButton];
    }
    
    return [NSArray arrayWithArray:buttons];
    
}

- (void)setUpPolygonForButton:(UIView *)button withVertices:(CGFloat)vertices initialPointAngle:(CGFloat)initialAngle cornerRadius:(CGFloat)pCornerRadius pBorderWidth:(CGFloat)lineWidth borderColor:(CGColorRef)pBorderColor{
    
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
