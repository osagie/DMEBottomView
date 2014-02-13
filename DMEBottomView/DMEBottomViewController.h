//
//  DMEBottomViewViewController.h
//  iWine
//
//  Created by David Getapp on 03/02/14.
//  Copyright (c) 2014 get-app. All rights reserved.
//

typedef enum {
    DMEBottomViewControllerPositionLeft = 0,
    DMEBottomViewControllerPositionRight,
    DMEBottomViewControllerPositionCenter
} DMEBottomViewControllerPosition;

typedef void (^DMEBottomViewControllerCompletionBlock)();

@interface DMEBottomViewController : UIViewController

@property (nonatomic) DMEBottomViewControllerPosition position;
@property (strong, nonatomic) UIColor *buttonBackgroundColor;
@property (strong, nonatomic) UIColor *buttonArrowColor;
@property (strong, nonatomic) UIColor *buttonBorderColor;

//Singleton method
+(instancetype)sharedInstance;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withButtonImage:(UIImage *)aImage;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withViewHeight:(NSUInteger)aHeight;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withButtonImage:(UIImage *)aImage withViewHeight:(NSUInteger)aHeight;

-(void)toogle:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock;

-(void)open:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock;

-(void)close:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock;

@end
