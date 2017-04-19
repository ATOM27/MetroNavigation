//
//  Station.m
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 18.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMStation.h"

@implementation EMStation

- (instancetype)initWithName:(NSString*)name parentBranch:(EMBranch*)parentBranch
{
    self = [super init];
    if (self) {
        self.name = name;
        self.parrentBranch = parentBranch;
    }
    return self;
}

@end
