//
//  EMStationCell.m
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 19.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMStationCell.h"

@interface EMStationCell()

@property (strong, nonatomic) IBOutlet UIView *circleView;
@property (strong, nonatomic) IBOutlet UILabel *stationNameLabel;

@end

@implementation EMStationCell

-(void)configureWithName:(NSString*)name circleColor:(UIColor*)color{
    self.stationNameLabel.text = name;
    self.circleView.layer.cornerRadius = CGRectGetWidth(self.circleView.frame)/2;
    self.circleView.backgroundColor = color;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.stationNameLabel.text = nil;
    self.circleView.backgroundColor = [UIColor whiteColor];
}

+(NSString*)reuseIdentifier{
    return @"Cell";
}


@end
