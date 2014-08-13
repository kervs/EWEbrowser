//
//  AwesomeFloatingToolbar.h
//  Browser
//
//  Created by Kervins Valcourt on 8/8/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AwesomeFloatingToolbar;

@protocol AwesomeFloatingToolbarDelegate <NSObject>

@optional

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didSelectButtonWithTitle:(NSString *)title;
- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar didTryToPanWithOffset:(CGPoint)offset;

- (void) floatingToolbar:(AwesomeFloatingToolbar *)toolbar TryToPinchWithScale:(UIPinchGestureRecognizer *)recognizer;



@end

@interface AwesomeFloatingToolbar : UIView
- (instancetype) initWithFourTitles:(NSArray *)titles;

- (void) addTarget:(id)enabled forButtonWithTitle:(NSString *)title andAction: (SEL) things;
- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title;


- (void) establishButtonColors:(NSInteger)offset;

@property (nonatomic, weak) id <AwesomeFloatingToolbarDelegate> delegate;
@property (nonatomic, assign) NSInteger colorOffset;

@end
