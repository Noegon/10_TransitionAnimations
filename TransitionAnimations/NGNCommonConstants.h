//
//  NGNCommonConstants.h
//  TransitionAnimations
//
//  Created by Stafeyev Alexei on 23/08/2017.
//  Copyright © 2017 Stafeyev Alexei. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - segue names

static const NSString *NGNSegueModalPresentation = @"NGNSegueModalPresentation";
static const NSString *NGNSegueNavigationPresentation = @"NGNSegueNavigationPresentation";
static const NSString *NGNSegueNavigationCustomPresentation = @"NGNSegueNavigationCustomPresentation";

//ModalPresentation storyboard
static const NSString *NGNSegueModalPresentationFirstToSecond = @"NGNSegueModalPresentationFirstToSecond";
static const NSString *NGNSegueModalPresentationSecondToFirst = @"NGNSegueModalPresentationSecondToFirst";

#pragma mark - storyboards Ids

static const NSString *NGNStoryboardMain = @"Main";
static const NSString *NGNStoryboardModalPresentation = @"ModalPresentation";
static const NSString *NGNStoryboardNavigablePresentation = @"NavigablePresentation";

@interface NGNCommonConstants : NSObject

@end
