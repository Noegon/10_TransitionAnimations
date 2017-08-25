//
//  NGNModalFirstViewController.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNCommonConstants.h"
#import "NGNModalFirstViewController.h"
#import "NGNModalPresentationTransitionDelegate.h"

@interface NGNModalFirstViewController () <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NGNModalPresentationTransitionDelegate *transitionDelegate;
@property (strong, nonatomic) IBOutlet UIScreenEdgePanGestureRecognizer *interactiveTransitionRecognizer;

@end

@implementation NGNModalFirstViewController

// Action method for the interactiveTransitionRecognizer.
- (IBAction)interactiveTransitionRecognizerAction:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan)
        [self performSegueWithIdentifier:NGNSegueModalPresentationFirstToSecond sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NGNSegueModalPresentationFirstToSecond]) {
        UIViewController *destinationViewController = segue.destinationViewController;
        
        NGNModalPresentationTransitionDelegate *transitionDelegate = self.transitionDelegate;
        
        if ([sender isKindOfClass:UIGestureRecognizer.class]) {
            transitionDelegate.gestureRecognizer = sender;
        } else {
            transitionDelegate.gestureRecognizer = nil;
        }

        transitionDelegate.targetEdge = UIRectEdgeLeft;
        
        destinationViewController.transitioningDelegate = transitionDelegate;
        
        destinationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}

// Lazy transition delegate getter
- (NGNModalPresentationTransitionDelegate *)transitionDelegate {
    if (_transitionDelegate == nil)
        _transitionDelegate = [[NGNModalPresentationTransitionDelegate alloc] init];
    
    return _transitionDelegate;
}

#pragma mark Unwind Actions

- (IBAction)unwindToModalFirstViewController:(UIStoryboardSegue *)unwindSegue { }

@end
