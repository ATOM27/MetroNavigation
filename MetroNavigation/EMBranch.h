//
//  Branch.h
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 18.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EMBranch : NSObject

typedef NS_ENUM(NSInteger, EMBranchColor){
    EMBranchColorGreen,
    EMBranchColorRed,
    EMBranchColorBlue
};

@property(assign ,nonatomic) EMBranchColor colorValue;
@property(strong, nonatomic) NSMutableArray* stationsArray;

- (instancetype)initWithColor:(EMBranchColor)color;

+(NSArray*)stationsNameForRed;
+(NSArray*)stationsNameForGreen;
+(NSArray*)stationsNameForBlue;

@end
