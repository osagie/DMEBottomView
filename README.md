DMEBottomView
=============

DMEBottomView is a simple view to put on bottom of other view.

![alt tag](https://raw.github.com/damarte/DMEBottomView/master/Screenshots/iphone.png)

![alt tag](https://raw.github.com/damarte/DMEBottomView/master/Screenshots/ipad.png)


##Instalation

Cocoapods, or copy the contents of /DMEBottomView into your project.

##Demo App

Navigate to /DMEBottomViewExample and open the proyect file.

##How do I use DMEBottomView

Include the following four files in your project:

```
DMEBottomView.h
DMEBottomView.m
```

You create a DMEBottomView by calling:

```
-(void)createInViewController:withView:

-(void)createInViewController:withView:withButtonImage:

-(void)createInViewController:withView:withViewHeight:

-(void)createInViewController:withView:withButtonImage:withViewHeight:
```

##Opening and Closing

You can let the user open and close the view manually, or you can control it programmatically.

```
-(void)toogle:

-(void)open:

-(void)close:
```
