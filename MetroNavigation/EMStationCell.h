//
//  EMStationCell.h
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 19.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMStationCell : UITableViewCell

-(void)configureWithName:(NSString*)name circleColor:(UIColor*)color;
-(void)prepareForReuse;

+(NSString*)reuseIdentifier;


@end
