//
//  NGNModalPresentationTransitionDelegate.h
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGNModalPresentationTransitionDelegate : NSObject <UIViewControllerTransitioningDelegate>

// If this transition will be interactive, this property is set to the
// gesture recognizer which will drive the interactivity.
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer *gestureRecognizer;

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end
