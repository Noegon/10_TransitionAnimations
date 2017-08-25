//
//  NGNCommonConstants.h
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - segue names

static NSString *const NGNSegueModalPresentation = @"NGNSegueModalPresentation";
static NSString *const NGNSegueNavigationPresentation = @"NGNSegueNavigationPresentation";
static NSString *const NGNSegueNavigationCustomPresentation = @"NGNSegueNavigationCustomPresentation";

//ModalPresentation storyboard
static NSString *const NGNSegueModalPresentationFirstToSecond = @"NGNSegueModalPresentationFirstToSecond";
static NSString *const NGNSegueModalPresentationSecondToFirst = @"NGNSegueModalPresentationSecondToFirst";

#pragma mark - storyboards Ids

static NSString *const NGNStoryboardMain = @"Main";
static NSString *const NGNStoryboardModalPresentation = @"ModalPresentation";
static NSString *const NGNStoryboardNavigablePresentation = @"NavigablePresentation";

@interface NGNCommonConstants : NSObject

@end
