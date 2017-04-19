//
//  Station.h
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 18.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EMBranch.h"
@interface EMStation : NSObject

@property(strong, nonatomic) NSString* name;
@property(weak, nonatomic) EMBranch* parrentBranch;
@property(strong, nonatomic) EMStation* stationTransition;

- (instancetype)initWithName:(NSString*)name parentBranch:(EMBranch*)parentBranch;

@end
