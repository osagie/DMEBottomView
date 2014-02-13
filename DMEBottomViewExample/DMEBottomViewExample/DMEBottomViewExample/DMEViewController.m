//
//  DMEViewController.m
//  DMEBottomViewExample
//
//  Created by David Getapp on 10/02/14.
//
//

#import "DMEViewController.h"
#import "DMEBottomViewController.h"

@interface DMEViewController ()

@end

@implementation DMEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIView *view = [[UIView alloc] init];
    view.backgroundColor= [UIColor blackColor];
    view.alpha = 0.95;
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Bottom view";
    label.frame = CGRectMake(10, 15, 320, 30);
    [view addSubview:label];
    
    [DMEBottomViewController sharedInstance].position = DMEBottomViewControllerPositionCenter;
    [DMEBottomViewController sharedInstance].buttonBackgroundColor = [UIColor darkGrayColor];
    [DMEBottomViewController sharedInstance].buttonArrowColor = [UIColor whiteColor];
    [DMEBottomViewController sharedInstance].buttonBorderColor = [UIColor lightGrayColor];
    [[DMEBottomViewController sharedInstance] createInViewController:self withView:view withViewHeight:100];
}

- (IBAction)open:(id)sender {
    [[DMEBottomViewController sharedInstance] open:YES withCompletionBlock:^{
        NSLog(@"Open");
    }];
}

- (IBAction)close:(id)sender {
    [[DMEBottomViewController sharedInstance] close:YES withCompletionBlock:^{
        NSLog(@"Close");
    }];
}

- (IBAction)toogle:(id)sender {
    [[DMEBottomViewController sharedInstance] toogle:YES withCompletionBlock:^{
        NSLog(@"Toogle");
    }];
}

@end
