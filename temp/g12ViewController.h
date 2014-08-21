//
//  g12ViewController.h
//  temp
//
//  Created by Anton on 8/20/14.
//  Copyright (c) 2014 g12-Squad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface g12ViewController : UIViewController
 
- (IBAction)arc4randomPunch:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *currentSpeedLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxSpeedLabel;

@end