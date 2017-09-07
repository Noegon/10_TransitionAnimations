//
//  NGNCustomTransitionAnimator.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "NGNCustomTransitionAnimator.h"

@interface NGNCustomTransitionAnimator ()

@end

@implementation NGNCustomTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 1.25;
}


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;

    UIView *fromView;
    UIView *toView;
    
    // In iOS 8, the viewForKey: method was introduced to get views that the
    // animator manipulates.  This method should be preferred over accessing
    // the view of the fromViewController/toViewController directly.
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    BOOL isPush = ([toViewController.navigationController.viewControllers indexOfObject:toViewController] > [fromViewController.navigationController.viewControllers indexOfObject:fromViewController]);
    
    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    [containerView addSubview:toView];
    
    UIImage *fromViewSnapshot;
    __block UIImage *toViewSnapshot;
    
    // Snapshot the fromView.
    UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
    [fromView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
    fromViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // To avoid a blank snapshot, defer snapshotting the incoming view until it
    // has had a chance to perform layout and drawing (1 run-loop cycle).
    dispatch_async(dispatch_get_main_queue(), ^{
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, YES, containerView.window.screen.scale);
        [toView drawViewHierarchyInRect:containerView.bounds afterScreenUpdates:NO];
        toViewSnapshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    UIView *transitionContainer = [[UIView alloc] initWithFrame:containerView.bounds];
    transitionContainer.opaque = YES;
    transitionContainer.backgroundColor = UIColor.blackColor;
    [containerView addSubview:transitionContainer];
    
    // Apply a perpective transform to the sublayers of transitionContainer.
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -900.0;
    transitionContainer.layer.sublayerTransform = t;
    
    // The size and number of slices is a function of the width.
    CGFloat sliceSize = round(CGRectGetWidth(transitionContainer.frame) / 10.f);
    NSUInteger horizontalSlices = ceil(CGRectGetWidth(transitionContainer.frame) / sliceSize);
    NSUInteger verticalSlices = ceil(CGRectGetHeight(transitionContainer.frame) / sliceSize);
    
    // transitionSpacing controls the transition duration for each slice.
    // Higher values produce longer animations with multiple slices having
    // their animations 'in flight' simultaneously.
    const CGFloat transitionSpacing = 160.f;
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    CGVector transitionVector = CGVectorMake(CGRectGetMinX(transitionContainer.bounds) - CGRectGetMaxX(transitionContainer.bounds), 0);
    
    CGFloat transitionVectorLength = sqrtf( transitionVector.dx * transitionVector.dx + transitionVector.dy * transitionVector.dy );
    CGVector transitionUnitVector = CGVectorMake(transitionVector.dx / transitionVectorLength, transitionVector.dy / transitionVectorLength);
   
    // here we cut fromView to different slices
    for (NSUInteger y = 0 ; y < verticalSlices; y++) {
        for (NSUInteger x = 0; x < horizontalSlices; x++) {
            CALayer *fromContentLayer = [CALayer new];
            fromContentLayer.frame = CGRectMake(x * sliceSize * -1.f,
                                                y * sliceSize * -1.f,
                                                containerView.bounds.size.width,
                                                containerView.bounds.size.height);
            fromContentLayer.rasterizationScale = fromViewSnapshot.scale;
            fromContentLayer.contents = (__bridge id)fromViewSnapshot.CGImage;
            
            CALayer *toContentLayer = [CALayer new];
            toContentLayer.frame = CGRectMake(x * sliceSize * -1.f,
                                              y * sliceSize * -1.f,
                                              containerView.bounds.size.width,
                                              containerView.bounds.size.height);
            
            // Snapshotting the toView was deferred so we must also defer applying
            // the snapshot to the layer's contents.
            dispatch_async(dispatch_get_main_queue(), ^{
                // Disable actions so the contents are applied without animation.
                BOOL wereActiondDisabled = [CATransaction disableActions];
                [CATransaction setDisableActions:YES];
                
                toContentLayer.rasterizationScale = toViewSnapshot.scale;
                toContentLayer.contents = (__bridge id)toViewSnapshot.CGImage;
                
                [CATransaction setDisableActions:wereActiondDisabled];
            });
            
            UIView *toCheckboardSquareView = [UIView new];
            toCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            toCheckboardSquareView.opaque = NO;
            toCheckboardSquareView.layer.masksToBounds = YES;
            toCheckboardSquareView.layer.doubleSided = NO;
            [toCheckboardSquareView.layer addSublayer:toContentLayer];
            
            UIView *fromCheckboardSquareView = [UIView new];
            fromCheckboardSquareView.frame = CGRectMake(x * sliceSize, y * sliceSize, sliceSize, sliceSize);
            fromCheckboardSquareView.opaque = NO;
            fromCheckboardSquareView.layer.masksToBounds = YES;
            fromCheckboardSquareView.layer.doubleSided = NO;
            fromCheckboardSquareView.layer.transform = CATransform3DIdentity;
            [fromCheckboardSquareView.layer addSublayer:fromContentLayer];
            
            [transitionContainer addSubview:toCheckboardSquareView];
            [transitionContainer addSubview:fromCheckboardSquareView];
        }
    }
    
    
    // Used to track how many slices have animations which are still in flight.
    __block NSUInteger sliceAnimationsPending = 0;

    for (NSUInteger y = 0; y < verticalSlices; y++) {
        for (NSUInteger x = 0; x < horizontalSlices; x++) {
            
            UIView *toCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2)];
            UIView *fromCheckboardSquareView = transitionContainer.subviews[y * horizontalSlices * 2 + (x * 2 + 1)];
            
            CGVector  sliceOriginVector;
            
            if (isPush) {
                sliceOriginVector = CGVectorMake(CGRectGetMidX(fromCheckboardSquareView.frame) - CGRectGetMidX(transitionContainer.bounds), 0);
            } else {
                if (y % 2 == 0) {
                    sliceOriginVector = CGVectorMake(CGRectGetMidX(fromCheckboardSquareView.frame) - CGRectGetMidX(transitionContainer.bounds), 0);
                } else {
                    sliceOriginVector = CGVectorMake(-(CGRectGetMidX(fromCheckboardSquareView.frame)) - CGRectGetMidX(transitionContainer.bounds), 0);
                }
            }
            
            // Project sliceOriginVector onto transitionVector.
            CGFloat dot = sliceOriginVector.dx * transitionVector.dx + sliceOriginVector.dy * transitionVector.dy;
            CGVector projection = CGVectorMake(transitionUnitVector.dx * dot/transitionVectorLength,
                                               transitionUnitVector.dy * dot/transitionVectorLength);
            
            // Compute the length of the projection.
            CGFloat projectionLength = sqrtf( projection.dx * projection.dx + projection.dy * projection.dy );
            
            NSTimeInterval startTime = projectionLength/(transitionVectorLength + transitionSpacing) * transitionDuration;
            NSTimeInterval duration = ( (projectionLength + transitionSpacing)/(transitionVectorLength + transitionSpacing) * transitionDuration ) - startTime;
            
            sliceAnimationsPending++;
            
            [UIView animateWithDuration:duration delay:startTime options:0 animations:^{
                fromCheckboardSquareView.alpha = 0;
                toCheckboardSquareView.alpha = 1;
            } completion:^(BOOL finished) {
                // Finish the transition once the final animation completes.
                if (--sliceAnimationsPending == 0) {
                    
                    BOOL wasCancelled = [transitionContext transitionWasCancelled];
                    
                    [transitionContainer removeFromSuperview];
                    
                    // When we complete, tell the transition context
                    // passing along the BOOL that indicates whether the transition
                    // finished or not.
                    [transitionContext completeTransition:!wasCancelled];
                }
            }];
        }
    }
}

@end
