//
//  DMEBottomViewViewController.h
//  iWine
//
//  Created by David Getapp on 03/02/14.
//  Copyright (c) 2014 get-app. All rights reserved.
//

@interface DMEBottomViewController : UIViewController

//Singleton method
+(instancetype)sharedInstance;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withButtonImage:(UIImage *)aImage;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withViewHeight:(NSUInteger)aHeight;

-(void)createInViewController:(UIViewController *)aViewController withView:(UIView *)aView withButtonImage:(UIImage *)aImage withViewHeight:(NSUInteger)aHeight;

-(void)toogle:(BOOL)animated;

-(void)open:(BOOL)animated;

-(void)close:(BOOL)animated;

@end
