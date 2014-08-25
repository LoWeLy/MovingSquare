//
//  g12ViewController.m
//  temp
//
//  Created by Anton on 8/20/14.
//  Copyright (c) 2014 g12-Squad. All rights reserved.
//

#import "g12ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface g12ViewController () {
    double speedX, speedY, addSpeed, maxSpeed, currentSpeed, minAxisSpeed; //Points per second
    double angle;
    CALayer *speedAndAngleDisplay;
    UIView *moveSpace;
    UIView *movingSquare;
    CALayer *dot;
    float displayerSize;
    float radius;
}

@end

@implementation g12ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __block BOOL dotMoveToDefaultPosition = NO;
    displayerSize = 100;
    radius = 5;
    double size = 20.0;
    angle = arc4random()%360;
	// Do any additional setup after loading the view, typically from a nib..
//    CABasicAnimation *noAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    moveSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20 - displayerSize)];
    movingSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    dot = [CALayer layer];
    speedAndAngleDisplay = [CALayer layer];
    
    [speedAndAngleDisplay addSublayer:dot];
    [moveSpace addSubview:movingSquare];
    
//    speedAndAngleDisplay.borderColor = [UIColor blackColor].CGColor;
//    speedAndAngleDisplay.borderWidth = 1.0;
    
    [dot setMasksToBounds:YES];
    [dot setCornerRadius:radius];
    dot.frame = CGRectMake(displayerSize / 2 - radius, displayerSize / 2 - radius, radius * 2, radius * 2);
    speedAndAngleDisplay.frame = CGRectMake(self.view.frame.size.width - displayerSize, self.view.frame.size.height - displayerSize, displayerSize, displayerSize);
    speedAndAngleDisplay.borderColor = [UIColor blackColor].CGColor;
    speedAndAngleDisplay.borderWidth = 1.0;
    moveSpace.layer.borderColor = [UIColor blackColor].CGColor;
    moveSpace.layer.borderWidth = 1.0;
    
    dot.backgroundColor = [UIColor blackColor].CGColor;
    
    movingSquare.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:moveSpace];
    [self.view.layer addSublayer:speedAndAngleDisplay];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double x = moveSpace.frame.size.width / 2 - size / 2;
        double y = moveSpace.frame.size.height / 2 - size / 2;
        [movingSquare setTransform:CGAffineTransformMakeTranslation(x, y)];
        addSpeed = 100.0;
        minAxisSpeed = 30.0;
        currentSpeed = addSpeed;
        maxSpeed = addSpeed;
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval currentTime;
        speedX = addSpeed * cos(M_PI/180.0*angle);
        speedY = addSpeed * sin(M_PI/180.0*angle);
        if (fabs(speedX) < minAxisSpeed) speedX = speedX / speedX * minAxisSpeed;
        if (fabs(speedY) < minAxisSpeed) speedX = speedY / speedY * minAxisSpeed;
        addSpeed = 0;
        _currentSpeedLabel.text = [NSString stringWithFormat:@"Current speed: %.3f",currentSpeed];
        _maxSpeedLabel.text = [NSString stringWithFormat:@"Max speed: %.3f",maxSpeed];
        while (YES) {
            currentTime = [NSDate timeIntervalSinceReferenceDate];
            x += (currentTime - startTime) * speedX;
            y += (currentTime - startTime) * speedY;
            startTime = currentTime;
            if (x > moveSpace.frame.size.width - size) {
                x = moveSpace.frame.size.width - size;
                speedX = fabs(speedX) * -0.9;
                speedX += addSpeed * cos(M_PI/180.0*angle);
                if (speedX > -minAxisSpeed) speedX = -minAxisSpeed;
//                speedY += addSpeed * sin(M_PI/180.0*angle);
                addSpeed = 0;
                dotMoveToDefaultPosition = YES;
            }
            if (y > moveSpace.frame.size.height - size) {
                y = moveSpace.frame.size.height - size;
                speedY = fabs(speedY) * -0.9;
//                speedX += addSpeed * cos(M_PI/180.0*angle);
                speedY += addSpeed * sin(M_PI/180.0*angle);
                if (speedY > -minAxisSpeed) speedY = -minAxisSpeed;
                addSpeed = 0;
                dotMoveToDefaultPosition = YES;
            }
            if (x < 0) {
                x = 0;
                speedX = fabs(speedX) * 0.9;
                speedX += addSpeed * cos(M_PI/180.0*angle);
                if (speedX < minAxisSpeed) speedX = minAxisSpeed;
//                speedY += addSpeed * sin(M_PI/180.0*angle);
                addSpeed = 0;
                dotMoveToDefaultPosition = YES;
            }
            if (y < 0) {
                y = 0;
                speedY = fabs(speedY) * 0.9;
//                speedX += addSpeed * cos(M_PI/180.0*angle);
                speedY += addSpeed * sin(M_PI/180.0*angle);
                if (speedY < minAxisSpeed) speedY = minAxisSpeed;
                addSpeed = 0;
                dotMoveToDefaultPosition = YES;
            }
            currentSpeed = sqrt(speedX*speedX + speedY*speedY);
            if (currentSpeed > maxSpeed) {
                maxSpeed = currentSpeed;
            }
            if (!movingSquare.layer.needsDisplay) {
                dispatch_async(dispatch_get_main_queue(),^{
                    
                    [movingSquare setTransform:CGAffineTransformMakeTranslation(x, y)];

//                    CGPoint point = CGPointMake(x, y);
//                    noAnimation.fromValue = [movingSquare valueForKey:@"position"];
//                    noAnimation.toValue = [NSValue valueWithCGPoint:point];
//                    noAnimation.duration = 0.05;
//                    noAnimation.fillMode = kCAFillModeForwards;
//                    movingSquare.layer.position = CGPointMake(x, y);
//                    [movingSquare.layer addAnimation:noAnimation forKey:@"position"];
                    
                    [movingSquare setNeedsDisplay];
//                    [movingSquare.layer removeAllAnimations];
                    if (!dot.needsDisplay) {
                        //                    [dot removeAllAnimations];
                        if (dotMoveToDefaultPosition) {
                            dot.position = CGPointMake(displayerSize / 2, displayerSize / 2);
                            dotMoveToDefaultPosition = NO;
                        }
                        [dot setNeedsDisplay];
                        
                    }
                    _currentSpeedLabel.text = [NSString stringWithFormat:@"Current speed: %.3f",currentSpeed];
                    _maxSpeedLabel.text = [NSString stringWithFormat:@"Max speed: %.3f",maxSpeed];
                });
            }
            usleep(30000);
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)arc4randomPunch:(id)sender {
    
    addSpeed = arc4random()%(100 - lrint(radius));
    angle = arc4random()%360;
    dispatch_async(dispatch_get_main_queue(),^{
        dot.position = CGPointMake(displayerSize / 2 + addSpeed * cos(M_PI/180.0*angle) / 2, displayerSize / 2 + addSpeed * sin(M_PI/180.0*angle) / 2);
        [dot setNeedsDisplay];
    });
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        moveSpace.frame = CGRectMake(0, 20, self.view.frame.size.height, self.view.frame.size.width - 20 - displayerSize);
        speedAndAngleDisplay.frame = CGRectMake(self.view.frame.size.height - displayerSize, self.view.frame.size.width - displayerSize, displayerSize, displayerSize);
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        moveSpace.frame = CGRectMake(0, 20, self.view.frame.size.height, self.view.frame.size.width - 20 - displayerSize);
        speedAndAngleDisplay.frame = CGRectMake(self.view.frame.size.height - displayerSize, self.view.frame.size.width - displayerSize, displayerSize, displayerSize);
    } else if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        moveSpace.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20 - displayerSize);
        speedAndAngleDisplay.frame = CGRectMake(self.view.frame.size.width - displayerSize, self.view.frame.size.height - displayerSize, displayerSize, displayerSize);
    }
}

@end
