//
//  EMSelectStationViewController.m
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 19.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMSelectStationViewController.h"
#import "EMBranch.h"
#import "EMStation.h"
#import "EMStationCell.h"
#import "EMMetroNavigationViewController.h"

@interface EMSelectStationViewController ()

@property (strong, nonatomic) NSOperation* currentOperation;
@property (strong, nonatomic) NSArray* sectionsArray;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation EMSelectStationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateSectionsInBackGroundFromArray:self.branchesArray withFilter:self.searchBar.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.textField.text = [[[[self.sectionsArray objectAtIndex:indexPath.section] stationsArray] objectAtIndex:indexPath.row] name];
    if(self.textFieldType == EMTextFieldTypeSource){
        EMMetroNavigationViewController* vc = [self.navigationController.viewControllers firstObject];
        vc.sourceStation = [[[self.sectionsArray objectAtIndex:indexPath.section] stationsArray] objectAtIndex:indexPath.row];
    }else if(self.textFieldType == EMTextFieldTypeDestination){
        EMMetroNavigationViewController* vc = [self.navigationController.viewControllers firstObject];
        vc.destinationStation = [[[self.sectionsArray objectAtIndex:indexPath.section] stationsArray] objectAtIndex:indexPath.row];
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* sectionTitle = nil;
    
    switch (section) {
        case EMBranchColorGreen:
            sectionTitle = @"Зеленая";
            break;
        case EMBranchColorRed:
            sectionTitle = @"Красная";
            break;
        case EMBranchColorBlue:
            sectionTitle = @"Синяя";
            break;
        default:
            break;
    }
    return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sectionsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.sectionsArray objectAtIndex:section] stationsArray] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMStationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[EMStationCell reuseIdentifier]];
    
    EMBranch* currentBranch = [self.sectionsArray objectAtIndex:indexPath.section];
    EMStation* currentStation = [currentBranch.stationsArray objectAtIndex:indexPath.row];
    
    [cell configureWithName:currentStation.name circleColor:[self getColorForBranch:currentBranch]];
    return cell;
}

#pragma mark - Help methods

-(UIColor*)getColorForBranch:(EMBranch*) branch{
    UIColor* color = nil;
    
    switch (branch.colorValue) {
        case EMBranchColorGreen:
            color = [UIColor greenColor];
            break;
        case EMBranchColorRed:
            color = [UIColor redColor];
            break;
        case EMBranchColorBlue:
            color = [UIColor blueColor];
            break;
        default:
            break;
    }
    
    return color;
}

-(void) generateSectionsInBackGroundFromArray:(NSArray*) array withFilter:(NSString*) filterString{
    
    [self.currentOperation cancel]; // if this method called the previous operation canceled
    
    __weak EMSelectStationViewController* weakSelf = self;
    
    self.currentOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSArray* sectionsArray = [weakSelf generateSectionsFromArray:array withFilter:filterString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.sectionsArray = sectionsArray;
            [weakSelf.tableView reloadData]; // reloadData need to use only in main queue
            
            self.currentOperation = nil;
        });
    }];
    
    [self.currentOperation start];
}

-(NSArray*) generateSectionsFromArray:(NSArray*) array withFilter:(NSString*) filterString{
    
    NSMutableArray* sectionsArray = [[NSMutableArray alloc] init];
    NSInteger lastStationColor = -1;
    
    for (EMBranch* currentBranch in array){
        for (EMStation* currentStation in currentBranch.stationsArray){
            if ([filterString length] > 0 && [currentStation.name rangeOfString:filterString].location == NSNotFound){
                continue;
            }
            
            EMBranch* branch = nil;
            
            if (currentBranch.colorValue != lastStationColor){
                
                branch = [[EMBranch alloc] initWithColor:currentBranch.colorValue];
                lastStationColor = branch.colorValue;
                
                [sectionsArray addObject:branch];
                
            }else{
                branch = [sectionsArray lastObject];
            }
            
            [branch.stationsArray addObject:currentStation];
        }
    }
    
    return sectionsArray;
    
}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self generateSectionsInBackGroundFromArray:self.branchesArray withFilter:searchText];
}


@end
