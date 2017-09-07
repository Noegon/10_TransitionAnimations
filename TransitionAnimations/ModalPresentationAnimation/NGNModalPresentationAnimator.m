//
//  NGNModalPresentationAnimator.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNModalPresentationAnimator.h"

@implementation NGNModalPresentationAnimator

- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge {
    self = [self init];
    if (self) {
        _targetEdge = targetEdge;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }

    //check is this opoeration presenting or dismissing
    BOOL isPresenting = (toViewController.presentingViewController == fromViewController);
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    CGVector offset;
    switch (self.targetEdge) {
        case UIRectEdgeTop:
            offset = CGVectorMake(0.f, 1.f);
            break;
        case UIRectEdgeBottom:
            offset = CGVectorMake(0.f, -1.f);
            break;
        case UIRectEdgeLeft:
            offset = CGVectorMake(1.f, 0.f);
            break;
        case UIRectEdgeRight:
            offset = CGVectorMake(-1.f, 0.f);
            break;
        default:
            offset = CGVectorMake(0.f, 0.f);
            break;
    }
    
    if (isPresenting) {
        //to draw out toView from the edge of the screen, its offset sould fully hide view beyound the edge
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width * offset.dx * -1,
                                             toFrame.size.height * offset.dy * -1);
    } else {
        fromView.frame = fromFrame;
        toView.frame = toFrame;
    }
    
    if (isPresenting) {
        [containerView addSubview:toView];
    } else {
        [containerView insertSubview:toView belowSubview:fromView];
    }
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    // begining of animation itself
    [UIView animateWithDuration:transitionDuration animations:^{
        if (isPresenting) {
            toView.frame = toFrame;
        } else {
            fromView.frame = CGRectOffset(fromFrame,
                                          fromFrame.size.width * offset.dx,
                                          fromFrame.size.height * offset.dy);
        }
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        
        if (wasCancelled) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!wasCancelled];
    }];
}

@end
