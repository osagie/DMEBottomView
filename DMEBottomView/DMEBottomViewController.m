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

#pragma mark Init methods

+(instancetype)sharedInstance
{
    static DMEBottomViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DMEBottomViewController alloc] init];
        sharedInstance.position = DMEBottomViewControllerPositionLeft; //Default left
        sharedInstance.buttonBackgroundColor = [UIColor whiteColor];
        sharedInstance.buttonArrowColor = [UIColor grayColor];
        sharedInstance.buttonBorderColor = [UIColor blackColor];
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
    if(!self.viewController){
        //Insert view
        self.view = aView;
        self.viewController = aViewController;
        self.height = aHeight;
        self.buttonImage = aImage;
        
        //Create button
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setImage:self.buttonImage forState:UIControlStateNormal];
        
        [self.button addTarget:self action:@selector(tapToogle) forControlEvents:UIControlEventTouchUpInside];
        
        [self.viewController.view addSubview:self.view];
        [self.viewController.view bringSubviewToFront:self.view];
        [self.viewController.view addSubview:self.button];
        [self.viewController.view bringSubviewToFront:self.button];
        
        //Set status
        self.viewVisible = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Screen rotation
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:)
                                                name:@"UIDeviceOrientationDidChangeNotification"
                                              object:nil];
    
    [self moveViews];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Screen rotation
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

#pragma mark Open/Close methods

-(void)open:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock
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
                
                if(completionBlock){
                    completionBlock();
                }
            }];
        }
        else{
            self.view.frame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
            self.button.frame = CGRectMake(self.button.frame.origin.x, newY-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
            self.viewVisible = YES;
            
            if(completionBlock){
                completionBlock();
            }
        }
        
    }
}

-(void)close:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock
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
                
                if(completionBlock){
                    completionBlock();
                }
            }];
        }
        else{
            self.view.frame = CGRectMake(self.view.frame.origin.x, newY, self.view.frame.size.width, self.view.frame.size.height);
            self.button.frame = CGRectMake(self.button.frame.origin.x, newY-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
            self.viewVisible = NO;
            
            if(completionBlock){
                completionBlock();
            }
        }
    }
}

-(void)toogle:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock
{
    if(self.viewVisible){
        [self close:animated withCompletionBlock:completionBlock];
    }
    else{
        [self open:animated withCompletionBlock:completionBlock];
    }
}

#pragma mark Util methods


-(void)tapToogle
{
    [self toogle:YES withCompletionBlock:nil];
}

-(void)didRotate:(NSNotification *)notification
{
    [self moveViews];
}

-(void)moveViews
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    NSInteger deltaY;
    if(!self.viewVisible){
        deltaY = 0;
    }
    else{
        deltaY = self.height;
    }
    
    NSInteger x;
    //if(orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown || orientation == UIDeviceOrientationUnknown){
    self.view.frame = CGRectMake(0, self.viewController.view.bounds.size.height-deltaY, self.viewController.view.bounds.size.width, self.height);
    
    switch (self.position) {
        case DMEBottomViewControllerPositionLeft:
            x = 0;
            break;
        case DMEBottomViewControllerPositionRight:
            x = self.viewController.view.bounds.size.width-self.buttonImage.size.width;
            break;
        case DMEBottomViewControllerPositionCenter:
            x = (self.viewController.view.bounds.size.width/2)-(self.buttonImage.size.width/2);
            break;
            
        default:
            break;
    }
    self.button.frame = CGRectMake(x, self.viewController.view.bounds.size.height-self.buttonImage.size.height-deltaY, self.buttonImage.size.width, self.buttonImage.size.height);
}

-(UIImage *)defaultButtonImage
{
    static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
        if (self.position == DMEBottomViewControllerPositionLeft) {
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(38, 38), NO, 0.0f);
            
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(-38, 0, 76, 76)];
            [self.buttonBackgroundColor setFill];
            [ovalPath fill];
            [self.buttonBorderColor setStroke];
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
            
            [self.buttonArrowColor setFill];
            [bezierPath fill];
            [self.buttonArrowColor setStroke];
            bezierPath.lineWidth = 1;
            [bezierPath stroke];
        }
        else if (self.position == DMEBottomViewControllerPositionRight){
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(38, 38), NO, 0.0f);
            
            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 76, 76)];
            [self.buttonBackgroundColor setFill];
            [ovalPath fill];
            [self.buttonBorderColor setStroke];
            ovalPath.lineWidth = 1;
            [ovalPath stroke];
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(10, 26.5)];
            [bezierPath addCurveToPoint: CGPointMake(23.52, 13.52) controlPoint1: CGPointMake(24.56, 12.52) controlPoint2: CGPointMake(23.52, 13.52)];
            [bezierPath addLineToPoint: CGPointMake(36, 26.5)];
            [bezierPath addLineToPoint: CGPointMake(31.84, 26.5)];
            [bezierPath addLineToPoint: CGPointMake(23.52, 17.51)];
            [bezierPath addLineToPoint: CGPointMake(14.16, 26.5)];
            [bezierPath addLineToPoint: CGPointMake(10, 26.5)];
            [bezierPath closePath];
            bezierPath.lineJoinStyle = kCGLineJoinRound;
            
            [self.buttonArrowColor setFill];
            [bezierPath fill];
            [self.buttonArrowColor setStroke];
            bezierPath.lineWidth = 1;
            [bezierPath stroke];
        }
        else{
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(76, 38), NO, 0.0f);

            //// Oval Drawing
            UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 1, 76, 76)];
            [self.buttonBackgroundColor setFill];
            [ovalPath fill];
            [self.buttonBorderColor setStroke];
            ovalPath.lineWidth = 1;
            [ovalPath stroke];
            
            
            //// Bezier Drawing
            UIBezierPath* bezierPath = [UIBezierPath bezierPath];
            [bezierPath moveToPoint: CGPointMake(25, 25.5)];
            [bezierPath addCurveToPoint: CGPointMake(38.52, 12.52) controlPoint1: CGPointMake(39.56, 11.52) controlPoint2: CGPointMake(38.52, 12.52)];
            [bezierPath addLineToPoint: CGPointMake(51, 25.5)];
            [bezierPath addLineToPoint: CGPointMake(46.84, 25.5)];
            [bezierPath addLineToPoint: CGPointMake(38.52, 16.51)];
            [bezierPath addLineToPoint: CGPointMake(29.16, 25.5)];
            [bezierPath addLineToPoint: CGPointMake(25, 25.5)];
            [bezierPath closePath];
            bezierPath.lineJoinStyle = kCGLineJoinRound;
            
            [self.buttonArrowColor setFill];
            [bezierPath fill];
            [self.buttonArrowColor setStroke];
            bezierPath.lineWidth = 1;
            [bezierPath stroke];
        }

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
