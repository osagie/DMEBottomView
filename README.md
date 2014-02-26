DMEBottomView
=============

DMEBottomView is a simple view to put on bottom of other view.

![alt tag](https://raw.github.com/damarte/DMEBottomView/master/Screenshots/iphone.png)

![alt tag](https://raw.github.com/damarte/DMEBottomView/master/Screenshots/ipad.png)


##Instalation

Cocoapods, by podfile

```
platform :ios, '6.0'
pod "DMEBottomView"
```

or copy the contents of `/DMEBottomView` into your project.

##Demo App

Navigate to `/DMEBottomViewExample` and open the proyect file.

##How do I use DMEBottomView

Include the following file in your project:

```
DMEBottomView.h
```

You create a DMEBottomView by calling:

```
-(void)createInViewController:withView:

-(void)createInViewController:withView:withOpenImage:withCloseImage:

-(void)createInViewController:withView:withViewHeight:

-(void)createInViewController:withView:withOpenImage:withCloseImage:withViewHeight:
```

##Opening and Closing

You can let the user open and close the view manually, or you can control it programmatically.

```
-(void)toogle:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock

-(void)open:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock

-(void)close:(BOOL)animated withCompletionBlock:(DMEBottomViewControllerCompletionBlock)completionBlock
```

##Customize

You can choose the positión of the button:

```
//Button align left (default)
[DMEBottomViewController sharedInstance].position = DMEBottomViewControllerPositionLeft;

//Button align center
[DMEBottomViewController sharedInstance].position = DMEBottomViewControllerPositionCenter;

//Button align right
[DMEBottomViewController sharedInstance].position = DMEBottomViewControllerPositionRight;   
```

You can choose the colors of default button if you don't replace then.

```
//Background color
[DMEBottomViewController sharedInstance].buttonBackgroundColor = [UIColor darkGrayColor];

//Arrow color
[DMEBottomViewController sharedInstance].buttonArrowColor = [UIColor whiteColor];

//Border color
[DMEBottomViewController sharedInstance].buttonBorderColor = [UIColor lightGrayColor];
```