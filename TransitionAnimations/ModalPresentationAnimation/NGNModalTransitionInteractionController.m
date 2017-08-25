//
//  NGNModalTransitionInteractionController.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 25/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNModalTransitionInteractionController.h"

@interface NGNModalTransitionInteractionController ()

@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
@property (nonatomic, strong, readonly) UIScreenEdgePanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readonly) UIRectEdge edge;

@end

@implementation NGNModalTransitionInteractionController

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer edgeForDragging:(UIRectEdge)edge {
    // That's fine idea to use asserts. But in my case (i'm using storyboard created gesture recognizers)
    // there is no necessity in such assertion: there's no possibility to set UIRectEdgeNone or UIRectEdgeAll
    NSAssert(edge == UIRectEdgeTop || edge == UIRectEdgeBottom ||
             edge == UIRectEdgeLeft || edge == UIRectEdgeRight,
             @"edgeForDragging must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.");
    
    self = [super init];
    if (self) {
        _gestureRecognizer = gestureRecognizer;
        _edge = edge;
        
        [_gestureRecognizer addTarget:self action:@selector(edgePanGesturePerformed:)];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Use -initWithGestureRecognizer:edgeForDragging:" userInfo:nil];
}

- (void)dealloc {
    [self.gestureRecognizer removeTarget:self action:@selector(edgePanGesturePerformed:)];
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // Save the transitionContext for later.
    self.transitionContext = transitionContext;
    
    [super startInteractiveTransition:transitionContext];
}

- (CGFloat)percentForGesture:(UIScreenEdgePanGestureRecognizer *)gesture {

    UIView *transitionContainerView = self.transitionContext.containerView;
    
    CGPoint locationInSourceView = [gesture locationInView:transitionContainerView];
    
    
    CGFloat width = CGRectGetWidth(transitionContainerView.bounds);
    CGFloat height = CGRectGetHeight(transitionContainerView.bounds);
    
    switch (self.edge) {
        case UIRectEdgeTop:
            return locationInSourceView.y / height;
        case UIRectEdgeBottom:
            return (height - locationInSourceView.y) / height;
        case UIRectEdgeLeft:
            return locationInSourceView.x / width;
        case UIRectEdgeRight:
            return (width - locationInSourceView.x) / width;
        default:
            return 0.f;
    }
}

// Action method for the gestureRecognizer. 'Switch-case' variant looks prettier than 'else if' in my NavigableAnimation module
- (void)edgePanGesturePerformed:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            // The Began state is handled by the view controllers.  In response
            // to the gesture recognizer transitioning to this state, they
            // will trigger the presentation or dismissal.
            break;
        case UIGestureRecognizerStateChanged:
            // We have been dragging! Update the transition context accordingly.
            [self updateInteractiveTransition:[self percentForGesture:gestureRecognizer]];
            break;
        case UIGestureRecognizerStateEnded:
            // Dragging has finished.
            // Complete or cancel, depending on how far we've dragged.
            if ([self percentForGesture:gestureRecognizer] >= 0.5f) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            // Something happened. cancel the transition.
            [self cancelInteractiveTransition];
            break;
    }
}


@end
