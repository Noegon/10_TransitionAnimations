//
//  NGNModalSecondViewController.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNCommonConstants.h"
#import "NGNModalSecondViewController.h"
#import "NGNModalPresentationTransitionDelegate.h"

@interface NGNModalSecondViewController ()

@property (strong, nonatomic) IBOutlet UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;

@end

@implementation NGNModalSecondViewController

// Action method for the interactiveTransitionRecognizer.
- (IBAction)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self performSegueWithIdentifier:NGNSegueModalPresentationSecondToFirst sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NGNSegueModalPresentationSecondToFirst]) {

        if ([self.transitioningDelegate isKindOfClass:NGNModalPresentationTransitionDelegate.class]) {
            NGNModalPresentationTransitionDelegate *transitionDelegate = self.transitioningDelegate;

            if ([sender isKindOfClass:UIGestureRecognizer.class]) {
                transitionDelegate.gestureRecognizer = sender;
            } else {
                transitionDelegate.gestureRecognizer = nil;
            }

            transitionDelegate.targetEdge = UIRectEdgeRight;
        }
    }
}

@end
