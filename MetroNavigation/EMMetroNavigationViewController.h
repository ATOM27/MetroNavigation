//
//  EMMetroNavigationViewController.h
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 18.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMStation.h"

@interface EMMetroNavigationViewController : UIViewController

@property(strong, nonatomic) EMStation* sourceStation;
@property(strong, nonatomic) EMStation* destinationStation;

@end
