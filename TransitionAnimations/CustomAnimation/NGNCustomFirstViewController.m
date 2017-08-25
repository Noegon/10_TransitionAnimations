//
//  NGNCustomFirstViewController.m
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import "NGNCustomFirstViewController.h"
#import "NGNCustomTransitionAnimator.h"

@interface NGNCustomFirstViewController () <UINavigationControllerDelegate>
@end


@implementation NGNCustomFirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [NGNCustomTransitionAnimator new];
}

@end
