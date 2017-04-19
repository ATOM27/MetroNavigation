//
//  EMSelectStationViewController.h
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 19.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMSelectStationViewController : UITableViewController

typedef NS_ENUM(NSInteger, EMTextFieldType){
    EMTextFieldTypeSource,
    EMTextFieldTypeDestination
};

@property(assign, nonatomic) EMTextFieldType textFieldType;
@property(strong, nonatomic) UITextField* textField;
@property(strong, nonatomic) NSArray* branchesArray;

@end
