//
//  NGNNavigationControllerDelegate.h
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNNavigationControllerDelegate.h"
#import "NGNNavigableAnimator.h"

@interface NGNNavigationControllerDelegate ()

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController; // our navigation controller - weak - because delegate
@property (strong, nonatomic) NGNNavigableAnimator *animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController; // object for interactivity

@end

@implementation NGNNavigationControllerDelegate

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesturePerformed:)];
    [self.navigationController.view addGestureRecognizer:rotationRecognizer];
    
    self.animator = [NGNNavigableAnimator new];
}

- (void)rotateGesturePerformed:(UIRotationGestureRecognizer *)recognizer {
    UIView* view = self.navigationController.view;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x <= CGRectGetMidX(view.bounds) &&
            self.navigationController.viewControllers.count > 1) { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            
            [self.navigationController popViewControllerAnimated:YES];

        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat currentRotationInRadians = recognizer.rotation;
        CGFloat d = fabs(currentRotationInRadians / (2 * M_PI));

        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (recognizer.velocity > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}


- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    // animators are equal in that case, but could be different
    if (operation == UINavigationControllerOperationPop) {
        return self.animator;
    } else if (operation == UINavigationControllerOperationPush) {
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactionController;
}

@end
