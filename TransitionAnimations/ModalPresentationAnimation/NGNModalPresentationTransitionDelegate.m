//
//  NGNModalPresentationTransitionDelegate.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNModalPresentationTransitionDelegate.h"
#import "NGNModalPresentationAnimator.h"
#import "NGNModalTransitionInteractionController.h"

@implementation NGNModalPresentationTransitionDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [[NGNModalPresentationAnimator alloc] initWithTargetEdge:self.targetEdge];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[NGNModalPresentationAnimator alloc] initWithTargetEdge:self.targetEdge];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.gestureRecognizer) {
        return [[NGNModalTransitionInteractionController alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    // We are doing identical animations, so we can use the same interaction controller
    return [self interactionControllerForPresentation:animator];
}

@end
