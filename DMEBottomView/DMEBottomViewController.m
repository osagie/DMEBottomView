//
//  DMEBottomViewViewController.m
//  iWine
//
//  Created by David Getapp on 03/02/14.
//  Copyright (c) 2014 get-app. All rights reserved.
//

#import "DMEBottomViewController.h"

@interface DMEBottomViewController ()

@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIView *view;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImage *buttonImage;
@property (nonatomic) NSUInteger height;
@property (nonatomic) BOOL viewVisible;

@end

@implementation DMEBottomViewController

+(instancetype)sharedInstance {
    static DMEBottomViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DMEBottomViewController alloc] init];
    });
    
    return sharedInstance;
}

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView
{
    [self createInViewController:aViewController withView:aView withButtonImage:[self defaultButtonImage] withViewHeight:aView.bounds.size.height];
}

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withButtonImage:(UIImage *)aImage
{
    [self createInViewController:aViewController withView:aView withButtonImage:aImage withViewHeight:aView.bounds.size.height];
}

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withViewHeight:(NSUInteger)aHeight
{
    [self createInViewController:aViewController withView:aView withButtonImage:[self defaultButtonImage] withViewHeight:aHeight];
}

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withButtonImage:(UIImage *)aImage withViewHeight:(NSUInteger)aHeight
{
    //Insert view
    self.view = aView;
    self.viewController = aViewController;
    self.height = aHeight;
    self.buttonImage = aImage;
    self.view.frame = CGRectMake(0, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height, self.height);
    
    //Create button
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:self.buttonImage forState:UIControlStateNormal];
    self.button.frame = CGRectMake(0, self.viewController.view.frame.size.width-self.buttonImage.size.height, self.buttonImage.size.width, self.buttonImage.size.height);
    
    [self.button addTarget:self action:@selector(toogle:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewController.view addSubview:self.view];
    [self.viewController.view bringSubviewToFront:self.view];
    [self.viewController.view addSubview:self.button];
    [self.viewController.view bringSubviewToFront:self.button];
    
    //Set status
    self.viewVisible = NO;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Screen rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didRotate:)
                                                name:@"UIDeviceOrientationDidChangeNotification"
                                              object:nil];
    
    [self moveViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Screen rotation
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"UIDeviceOrientationDidChangeNotification"];
}

-(void)open:(BOOL)animated
{
    if(!self.viewVisible){
        NSInteger newY = self.viewController.view.bounds.size.height-self.height;
        
        if(animated){
            UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
            [UIView animateWithDuration:0.5 delay:0 options:options animations:^{
                self.view.frame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
                self.button.frame = CGRectMake(self.button.frame.origin.x, newY-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
            } completion:^(BOOL finished) {
                self.viewVisible = YES;
            }];
        }
        else{
            self.view.frame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
            self.button.frame = CGRectMake(self.button.frame.origin.x, newY-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
            self.viewVisible = YES;
        }
        
    }
}

-(void)close:(BOOL)animated
{
    if(self.viewVisible){
        NSInteger newY = self.viewController.view.bounds.size.height;
        
        if(animated){
            UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
            [UIView animateWithDuration:0.5 delay:0 options:options animations:^{
                self.view.frame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
                self.button.frame = CGRectMake(self.button.frame.origin.x, newY-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
            } completion:^(BOOL finished) {
                self.viewVisible = NO;
            }];
        }
        else{
            self.view.frame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
            self.button.frame = CGRectMake(self.button.frame.origin.x, newY-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
            self.viewVisible = NO;
        }
    }
}

-(void)toogle:(BOOL)animated
{
    if(self.viewVisible){
        [self close:animated];
    }
    else{
        [self open:animated];
    }
}

-(void)didRotate:(NSNotification *)notification
{
    [self moveViews];
}

-(void)moveViews
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSArray *supportedOrientations = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UISupportedInterfaceOrientations"];
    
    if([supportedOrientations containsObject:[self deviceOrientationString:orientation]]){
        NSInteger deltaY;
        if(!self.viewVisible){
            deltaY = 0;
        }
        else{
            deltaY = self.height;
        }
        
        if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown){
            self.view.frame = CGRectMake(0, self.viewController.view.frame.size.height-deltaY, self.viewController.view.frame.size.width, self.height);
            self.button.frame = CGRectMake(0, self.viewController.view.frame.size.height-self.buttonImage.size.height-deltaY, self.buttonImage.size.width, self.buttonImage.size.height);
        }
        else if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight){
            self.view.frame = CGRectMake(0, self.viewController.view.frame.size.width-deltaY, self.viewController.view.frame.size.height, self.height);
            self.button.frame = CGRectMake(0, self.viewController.view.frame.size.width-self.buttonImage.size.height-deltaY, self.buttonImage.size.width, self.buttonImage.size.height);
        }
    }
}

-(UIImage *)defaultButtonImage
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(38, 38), NO, 0.0f);
        
        //// Color Declarations
        UIColor* color = [UIColor colorWithRed: 0.5 green: 0.5 blue: 0.5 alpha: 1];
        
        //// Oval Drawing
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-38, 0, 76, 76)];
        [[UIColor whiteColor] setFill];
        [ovalPath fill];
        [[UIColor blackColor] setStroke];
        ovalPath.lineWidth = 1;
        [ovalPath stroke];
        
        
        //// Bezier Drawing
        UIBezierPath* bezierPath = [UIBezierPath bezierPath];
        [bezierPath moveToPoint: CGPointMake(2.5, 26.5)];
        [bezierPath addCurveToPoint: CGPointMake(16.02, 13.52) controlPoint1: CGPointMake(17.06, 12.52) controlPoint2: CGPointMake(16.02, 13.52)];
        [bezierPath addLineToPoint: CGPointMake(28.5, 26.5)];
        [bezierPath addLineToPoint: CGPointMake(24.34, 26.5)];
        [bezierPath addLineToPoint: CGPointMake(16.02, 17.51)];
        [bezierPath addLineToPoint: CGPointMake(6.66, 26.5)];
        [bezierPath addLineToPoint: CGPointMake(2.5, 26.5)];
        [bezierPath closePath];
        bezierPath.lineJoinStyle = kCGLineJoinRound;
        
        [color setFill];
        [bezierPath fill];
        [color setStroke];
        bezierPath.lineWidth = 1;
        [bezierPath stroke];
        
        // get an image of the graphics context
        defaultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // end the context
        UIGraphicsEndImageContext();
	});
    
    return defaultImage;
}

- (NSString *)deviceOrientationString:(UIDeviceOrientation)orientation {
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            return @"UIInterfaceOrientationPortrait";
        case UIDeviceOrientationPortraitUpsideDown:
            return @"UIInterfaceOrientationPortraitUpsideDown";
        case UIDeviceOrientationLandscapeLeft:
            return @"UIInterfaceOrientationLandscapeLeft";
        case UIDeviceOrientationLandscapeRight:
            return @"UIInterfaceOrientationLandscapeRight";
        case UIDeviceOrientationUnknown:
            return @"Invalid Interface Orientation";
        default:
            return @"Invalid Interface Orientation";
    }
}

@end
