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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;

@property (nonatomic) UIDynamicAnimator *myAnimator;
@property (nonatomic) NSArray *myButtons;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelConstraint.constant = -80;
    [self.view setNeedsUpdateConstraints];
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
    self.myButtons = buttons3;
    [allbuttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
        CGRect frame = b.frame;
        frame.size.width *= 1.4;
      
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.labelConstraint.constant = 0;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:1.6 delay:0 usingSpringWithDamping:.55 initialSpringVelocity:15 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.myButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIButton *b = obj;
            
            CGPoint loc, locNew;
            loc = locNew = b.layer.position;
            locNew.y += 30;
            
            [UIView animateWithDuration:.3 delay:.05*idx options:UIViewAnimationOptionCurveLinear animations:^{
                b.layer.position = locNew;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.5 delay:0 usingSpringWithDamping:.4 initialSpringVelocity:50 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    b.layer.position = loc;
                } completion:nil];
            }];
            
            
        }];
    }];
    
    

}



- (void)buttonAction:(id)sender {    
    //just for fun
    
    UIButton *b = (UIButton *)sender;
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[b]];
    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[b]];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[b]];
    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(10, 20, 20, 20)];
    
    itemBehavior.elasticity = .3;
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
