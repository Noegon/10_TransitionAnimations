//
//  NGNNavigableAnimator.h
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNNavigableAnimator.h"

@implementation NGNNavigableAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [[transitionContext containerView] addSubview:toViewController.view];
    
    toViewController.view.alpha = 0;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.01, 0.01), CGAffineTransformMakeRotation(M_PI));
//        fromViewController.view.transform = CGAffineTransformMakeRotation(M_PI);
//        [self runSpinAnimationOnView:fromViewController.view duration:[self transitionDuration:transitionContext] rotations:2 repeat:0];
        
//        //making view smaller
//        CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
//        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
//        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01, 0.01, 1.0)];
//        scaleAnim.removedOnCompletion = YES;
//        
//        //making from view transparent
//        CABasicAnimation *opacityAnimFrom = [CABasicAnimation animationWithKeyPath:@"alpha"];
//        opacityAnimFrom.fromValue = [NSNumber numberWithFloat:1.0];
//        opacityAnimFrom.toValue = [NSNumber numberWithFloat:0.0];
//        opacityAnimFrom.removedOnCompletion = YES;
//        
//        //making rotation
//        CABasicAnimation* rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation */ * 3 /* custom multiplier */];
//        rotationAnimation.cumulative = YES;
//        rotationAnimation.repeatCount = HUGE_VALF;
//        rotationAnimation.removedOnCompletion = YES;
//        
//        
//        CAAnimationGroup *group1 = [[CAAnimationGroup alloc] init];
//        group1.animations = @[scaleAnim, opacityAnimFrom, rotationAnimation];
//        group1.duration = [self transitionDuration:transitionContext];
//        group1.removedOnCompletion = YES;
//        group1.duration = [self transitionDuration:transitionContext];
//        [fromViewController.view.layer addAnimation:group1 forKey:@"group1"];
        
        toViewController.view.alpha = 1;

    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

- (void)runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat ? HUGE_VALF : 0;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
