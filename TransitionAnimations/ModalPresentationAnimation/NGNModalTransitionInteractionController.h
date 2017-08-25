//
//  NGNModalTransitionInteractionController.h
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 25/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NGNModalTransitionInteractionController : UIPercentDrivenInteractiveTransition

- (instancetype)initWithGestureRecognizer:(UIScreenEdgePanGestureRecognizer*)gestureRecognizer edgeForDragging:(UIRectEdge)edge NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end
