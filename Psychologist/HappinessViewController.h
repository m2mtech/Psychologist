//
//  HappinessViewController.h
//  Happiness
//
//  Created by Martin Mandl on 17.07.12.
//  Copyright (c) 2012 m2m. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface HappinessViewController : UIViewController <SplitViewBarButtonItemPresenter>

@property (nonatomic) int happiness; // 0 = sad; 100 = happy

@end
