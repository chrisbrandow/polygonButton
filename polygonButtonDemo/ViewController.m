//
//  ViewController.m
//  polygonButtonDemo
//
//  Created by Chris Personal on 10/15/14.
//  Copyright (c) 2014 Flouu Apps. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+polygonButton.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@property (nonatomic) UIDynamicAnimator *myAnimator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.myAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    CGFloat viewHeight = self.view.frame.size.height;
    NSMutableArray *yPos = [NSMutableArray new];
    NSInteger numberOfRows = 5;
    
    for (NSInteger i = 0; i < numberOfRows; ++i) {
        yPos[i] = @((i + 1)*viewHeight/(numberOfRows + 1));
    }
    
    NSArray *buttons = [UIButton evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:[yPos[0] floatValue]];
    NSArray *buttons2 = [UIButton evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:[yPos[1] floatValue]];
    NSArray *buttons3 = [UIButton evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:[yPos[2] floatValue]];
    NSArray *buttons4 = [UIButton evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:[yPos[3] floatValue]];
    NSArray *buttons5 = [UIButton evenlySpacedGoldenRatioButtonsWith:5 width:self.view.frame.size.width yPos:[yPos[4] floatValue]];
    
    NSArray *allbuttons = @[buttons, buttons2, buttons3, buttons4, buttons5];
    
    [allbuttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"obj %@", obj);
        [obj enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *b = obj;
            [b setTitle:[NSString stringWithFormat:@"%zd", idx+1] forState:UIControlStateNormal];
            [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            b.backgroundColor = [UIColor colorWithRed:.1 green:.1 blue:.8 alpha:(2+(CGFloat)idx)/6];
            [self.view addSubview:b];
        }];
    }];
    
    
    [buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        [b setUpPolygonForButton:b withVertices:3+idx initialPointAngle:M_PI_2 cornerRadius:3 pBorderWidth:4 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.8 brightness:.9 alpha:1].CGColor];
    }];
    
    [buttons2 enumerateObjectsUsingBlock:^(UIButton *b, NSUInteger idx, BOOL *stop) {
        [b setUpPolygonForButton:b withVertices:4 initialPointAngle:M_PI_4 cornerRadius:(CGFloat)idx*5.0 pBorderWidth:16 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.8 brightness:.9 alpha:1].CGColor];
    }];
    
    [buttons3 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        [b setUpPolygonForButton:b withVertices:4 initialPointAngle:M_PI_2 cornerRadius:(CGFloat)idx*5.0 pBorderWidth:16 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.8 brightness:.9 alpha:1].CGColor];
        
    }];
    
    [buttons4 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        [b setUpPolygonForButton:b withVertices:5 initialPointAngle:M_PI_2 cornerRadius:3 pBorderWidth:1+5*(CGFloat)idx borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.8 brightness:.9 alpha:1].CGColor];
    }];

    [buttons5 enumerateObjectsUsingBlock:^(UIButton *b, NSUInteger idx, BOOL *stop) {

        [b setUpPolygonForButton:b withVertices:5 initialPointAngle:M_PI_4 cornerRadius:(CGFloat)idx*5.0 pBorderWidth:8 borderColor:[UIColor colorWithHue:((CGFloat)idx)/5 saturation:.8 brightness:.9 alpha:1].CGColor];
        }];
}

- (void)buttonAction:(id)sender {
    NSLog(@"you pushed button: %@", [[sender titleLabel] text]);
    
    //just for fun
    
    UIButton *b = (UIButton *)sender;
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[b]];
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[b]];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[b]];
    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(10, 20, 20, 20)];
    
    itemBehavior.elasticity = .9;
    collision.collisionDelegate = self;
    
    [self.myAnimator addBehavior:gravity];
    [self.myAnimator addBehavior:itemBehavior];
    [self.myAnimator addBehavior:collision];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {

    [self.myAnimator removeBehavior:behavior];
}
@end
