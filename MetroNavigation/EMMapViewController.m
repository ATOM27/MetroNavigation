//
//  EMMapViewController.m
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 20.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMMapViewController.h"

@interface EMMapViewController ()

@property (assign, nonatomic) CGFloat testScale;
@property (strong, nonatomic) IBOutlet UIImageView *mapImageView;
@property (assign, nonatomic) CGPoint delta;


@end

@implementation EMMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlePinch:)];
    
    pinchGesture.delegate = self;
    [self.view addGestureRecognizer:pinchGesture];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Gestures

-(void) handlePinch:(UIPinchGestureRecognizer*) pinchGesture{
    NSLog(@"Pich scale: %1.3f", pinchGesture.scale);
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan){
        self.testScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.testScale;
    self.mapImageView.transform = CGAffineTransformScale(self.mapImageView.transform, newScale, newScale);
    
    self.testScale = pinchGesture.scale;
}

-(void) handlePan:(UIPanGestureRecognizer*) panGesture{
    
    CGPoint pointInMainView = [panGesture locationInView:self.view];
    CGPoint pointInCurrentView = [panGesture locationInView:self.mapImageView];
    
    self.delta = CGPointMake(CGRectGetMidX(self.mapImageView.bounds) - pointInCurrentView.x,
                             CGRectGetMidY(self.mapImageView.bounds) - pointInCurrentView.y);

                         self.mapImageView.center = CGPointMake(pointInMainView.x + self.delta.x,
                                                                pointInMainView.y + self.delta.y);

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch* touch in touches){
        
        CGPoint point = [touch locationInView:self.view];
        
        UIView* newView = [self.view hitTest:point withEvent:event];
        
            
            CGPoint pointInDraggingView = [touch locationInView:self.mapImageView];
            
            self.delta = CGPointMake(CGRectGetMidX(self.mapImageView.bounds) - pointInDraggingView.x, CGRectGetMidY(self.mapImageView.bounds) - pointInDraggingView.y);
        
    }
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    for (UITouch* touch in touches){
        
        CGPoint point = [touch locationInView:self.view];
      
            
            self.mapImageView.center = CGPointMake(point.x + self.delta.x,
                                                   point.y + self.delta.y);
            
            
    
        }
    
    
}



@end
