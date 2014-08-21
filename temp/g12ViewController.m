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
    CALayer *moveSpace;
    CALayer *movingSquare;
    CALayer *dot;
    float displayerSize;
    float radius;
}

@end

@implementation g12ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib..
    CABasicAnimation *noAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    moveSpace = [CALayer layer];
    movingSquare = [CALayer layer];
    dot = [CALayer layer];
    speedAndAngleDisplay = [CALayer layer];
    
    [speedAndAngleDisplay addSublayer:dot];
    [moveSpace addSublayer:movingSquare];
    
//    speedAndAngleDisplay.borderColor = [UIColor blackColor].CGColor;
//    speedAndAngleDisplay.borderWidth = 1.0;
    displayerSize = 100;
    radius = 5;
    [dot setMasksToBounds:YES];
    [dot setCornerRadius:radius];
    dot.frame = CGRectMake(displayerSize / 2 - radius, displayerSize / 2 - radius, radius * 2, radius * 2);
    speedAndAngleDisplay.frame = CGRectMake(self.view.bounds.size.width - displayerSize, self.view.bounds.size.height - displayerSize, displayerSize, displayerSize);
    speedAndAngleDisplay.borderColor = [UIColor blackColor].CGColor;
    speedAndAngleDisplay.borderWidth = 1.0;
    moveSpace.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height - 20 - displayerSize);
    moveSpace.borderColor = [UIColor blackColor].CGColor;
    moveSpace.borderWidth = 1.0;
    
    dot.backgroundColor = [UIColor blackColor].CGColor;
    double size = 20.0;
    angle = arc4random()%360;
    movingSquare.backgroundColor = [UIColor blackColor].CGColor;
    
    [self.view.layer addSublayer:moveSpace];
    [self.view.layer addSublayer:speedAndAngleDisplay];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        double x = moveSpace.frame.size.width / 2 - size / 2;
        double y = moveSpace.frame.size.height / 2 - size / 2;
        movingSquare.frame = CGRectMake(0, 0, size, size);
        movingSquare.position = CGPointMake(x, y);
        addSpeed = 100.0;
        minAxisSpeed = 30.0;
        currentSpeed = addSpeed;
        maxSpeed = addSpeed;
        NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
        NSTimeInterval currentTime;
        speedX = addSpeed * cos(M_PI/180.0*angle);
        speedY = addSpeed * sin(M_PI/180.0*angle);
        addSpeed = 0;
        _currentSpeedLabel.text = [NSString stringWithFormat:@"Current speed: %.3f",currentSpeed];
        _maxSpeedLabel.text = [NSString stringWithFormat:@"Max speed: %.3f",maxSpeed];
        while (YES) {
            currentTime = [NSDate timeIntervalSinceReferenceDate];
            x += (currentTime - startTime) * speedX;
            y += (currentTime - startTime) * speedY;
            startTime = currentTime;
            if (x > moveSpace.frame.size.width - size / 2) {
                x = moveSpace.frame.size.width - size / 2;
                speedX = fabs(speedX) * -0.9;
                speedX += addSpeed * cos(M_PI/180.0*angle);
                if (speedX > -minAxisSpeed) speedX = -minAxisSpeed;
//                speedY += addSpeed * sin(M_PI/180.0*angle);
                addSpeed = 0;
                dot.position = CGPointMake(displayerSize / 2, displayerSize / 2);
            }
            if (y > moveSpace.frame.size.height - size / 2) {
                y = moveSpace.frame.size.height - size / 2;
                speedY = fabs(speedY) * -0.9;
//                speedX += addSpeed * cos(M_PI/180.0*angle);
                speedY += addSpeed * sin(M_PI/180.0*angle);
                if (speedY > -minAxisSpeed) speedY = -minAxisSpeed;
                addSpeed = 0;
                dot.position = CGPointMake(displayerSize / 2, displayerSize / 2);
            }
            if (x < size / 2) {
                x = size / 2;
                speedX = fabs(speedX) * 0.9;
                speedX += addSpeed * cos(M_PI/180.0*angle);
                if (speedX < minAxisSpeed) speedX = minAxisSpeed;
//                speedY += addSpeed * sin(M_PI/180.0*angle);
                addSpeed = 0;
                dot.position = CGPointMake(displayerSize / 2, displayerSize / 2);
            }
            if (y < size / 2) {
                y = size / 2;
                speedY = fabs(speedY) * 0.9;
//                speedX += addSpeed * cos(M_PI/180.0*angle);
                speedY += addSpeed * sin(M_PI/180.0*angle);
                if (speedY < minAxisSpeed) speedY = minAxisSpeed;
                addSpeed = 0;
                dot.position = CGPointMake(displayerSize / 2, displayerSize / 2);
            }
            currentSpeed = sqrt(speedX*speedX + speedY*speedY);
            if (currentSpeed > maxSpeed) {
                maxSpeed = currentSpeed;
            }
            if (!movingSquare.needsDisplay && ![movingSquare animationForKey:@"position"]) {
                dispatch_sync(dispatch_get_main_queue(),^{
                    
                    
                    CGPoint point = CGPointMake(x, y);
                    noAnimation.fromValue = [movingSquare valueForKey:@"position"];
                    noAnimation.toValue = [NSValue valueWithCGPoint:point];
                    noAnimation.duration = 0.1;
                    noAnimation.fillMode = kCAFillModeForwards;
                    movingSquare.position = CGPointMake(x, y);
                    [movingSquare addAnimation:noAnimation forKey:@"position"];
                    
                    [movingSquare setNeedsDisplay];
                    //                    [movingSquare removeAllAnimations];
                    
                    if (!dot.needsDisplay) {
                        //                    [dot removeAllAnimations];
                        [dot setNeedsDisplay];
                    }
                    _currentSpeedLabel.text = [NSString stringWithFormat:@"Current speed: %.3f",currentSpeed];
                    _maxSpeedLabel.text = [NSString stringWithFormat:@"Max speed: %.3f",maxSpeed];
                });
            } else {
                usleep(100000);
                [movingSquare removeAllAnimations];
            }
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)arc4randomPunch:(id)sender {
    
    addSpeed = arc4random()%100;
    angle = arc4random()%360;
    dot.frame = CGRectMake(displayerSize / 2 - radius + addSpeed * cos(M_PI/180.0*angle) / 2, displayerSize / 2 - radius + addSpeed * sin(M_PI/180.0*angle) / 2, radius * 2, radius * 2);
    [dot setNeedsDisplay];
}

@end
