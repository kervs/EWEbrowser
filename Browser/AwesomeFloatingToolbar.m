//
//  AwesomeFloatingToolbar.m
//  Browser
//
//  Created by Kervins Valcourt on 8/8/14.
//  Copyright (c) 2014 EastoftheWestEnd. All rights reserved.
//

#import "AwesomeFloatingToolbar.h"

@interface AwesomeFloatingToolbar ()

@property (nonatomic, strong) NSArray *currentTitles;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, weak) UIButton *currentbutton;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;



@end
@implementation AwesomeFloatingToolbar

- (instancetype) initWithFourTitles:(NSArray *)titles {
    // First, call the superclass (UIView)'s initializer, to make sure we do all that setup first.
    self = [super init];
    
    if (self) {
        
        // Save the titles, and set the 4 colors
        self.currentTitles = titles;
        self.colors = @[[UIColor colorWithRed:199/255.0 green:158/255.0 blue:203/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:105/255.0 blue:97/255.0 alpha:1],
                        [UIColor colorWithRed:222/255.0 green:165/255.0 blue:164/255.0 alpha:1],
                        [UIColor colorWithRed:255/255.0 green:179/255.0 blue:71/255.0 alpha:1]];
        
        NSMutableArray *buttonsArray = [[NSMutableArray alloc] init];
        
        // Make the 4 buttons
        for (NSString *currentTitle in self.currentTitles) {
            UIButton *button = [[UIButton alloc] init];
            
            button.alpha = 0.25;
            
            NSUInteger currentTitleIndex = [self.currentTitles indexOfObject:currentTitle]; // 0 through 3
            NSString *titleForThisbutton = [self.currentTitles objectAtIndex:currentTitleIndex];
            
            
            button.titleLabel.font = [UIFont systemFontOfSize:10];
            [button setTitle:titleForThisbutton forState:UIControlStateNormal];
            button.titleLabel.textColor = [UIColor whiteColor];
            
            
            [buttonsArray addObject:button];
        }
        
        self.buttons = buttonsArray;
        self.colorOffset = -1;
        [self establishButtonColors:0];
        
        for (UIButton *thisbutton in self.buttons) {
            [self addSubview:thisbutton];
        }
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFired:)];
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchFired:)];
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFired:)];
      
        
        [self addGestureRecognizer:self.panGesture];
        [self addGestureRecognizer:self.tapGesture];
        [self addGestureRecognizer:self.pinchGesture];
        [self addGestureRecognizer:self.longPressGesture];
     
    }
    
    return self;
}


- (void) layoutSubviews {
    // set the frames for the 4 buttons
    
    for (UIButton *thisbutton in self.buttons) {
        NSUInteger currentbuttonIndex = [self.buttons indexOfObject:thisbutton];
        
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) / 2;
        CGFloat buttonWidth = CGRectGetWidth(self.bounds) / 2;
        CGFloat buttonX = 0;
        CGFloat buttonY = 0;
        
        // adjust buttonX and buttonY for each button
        if (currentbuttonIndex < 2) {
            // 0 or 1, so on top
            buttonY = 0;
        } else {
            // 2 or 3, so on bottom
            buttonY = CGRectGetHeight(self.bounds) / 2;
        }
        
        if (currentbuttonIndex % 2 == 0) { // is currentbuttonIndex evenly divisible by 2?
            // 0 or 2, so on the left
            buttonX = 0;
        } else {
            // 1 or 3, so on the right
            buttonX = CGRectGetWidth(self.bounds) / 2;
        }
        
        thisbutton.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    }
}
#pragma mark - Touch Handling

- (UIButton *) buttonFromTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    UIView *subview = [self hitTest:location withEvent:event];
    return (UIButton *)subview;
}

    
    
    
    

- (void) tapFired:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [recognizer locationInView:self];
        UIView *tappedView = [self hitTest:location withEvent:nil];

        if ([self.buttons containsObject:tappedView]) {
            if ([self.delegate respondsToSelector:@selector(floatingToolbar:didSelectButtonWithTitle:)]) {
                [self.delegate floatingToolbar:self didSelectButtonWithTitle:((UIButton *)tappedView).titleLabel.text];
            }
        }
    }
}

- (void) panFired:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self];
        
        NSLog(@"New translation: %@", NSStringFromCGPoint(translation));
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:didTryToPanWithOffset:)]) {
            [self.delegate floatingToolbar:self didTryToPanWithOffset:translation];
        }
        
        [recognizer setTranslation:CGPointZero inView:self];
    }
}
- (void) pinchFired:(UIPinchGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        
        if ([self.delegate respondsToSelector:@selector(floatingToolbar:TryToPinchWithScale:)]) {
            [self.delegate floatingToolbar:self TryToPinchWithScale:recognizer];
        }

    }
}

- (void) longPressFired:(UILongPressGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
  
        
       
            [self establishButtonColors:self.colorOffset + 1];
        
    }
}


- (void)establishButtonColors:(NSInteger)offset {
   
    if (self.colorOffset == offset) {
        return;
    } else if (offset >= 4) {
        offset = 0;
    }
    self.colorOffset = offset;
    [self.buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSInteger colorIdx = (idx + offset) % [self.colors count];
        ((UIButton *)obj).backgroundColor = self.colors[colorIdx];
    }];
}



#pragma mark - Button Enabling

- (void) addTarget:(id)enabled forButtonWithTitle:(NSString *)title andAction: (SEL)things {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    for (UIButton *button in self.buttons) {
        [button removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        [button addTarget:enabled action:things forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}

- (void) setEnabled:(BOOL)enabled forButtonWithTitle:(NSString *)title {
    NSUInteger index = [self.currentTitles indexOfObject:title];
    if (index != NSNotFound) {
        UIButton *button = [self.buttons objectAtIndex:index];
        button.enabled = enabled;
        button.alpha = enabled ? 1.0 : 0.25;
        
    }
   
    
}

@end
