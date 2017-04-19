//
//  EMMetroNavigationViewController.m
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 18.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMMetroNavigationViewController.h"
#import "EMSelectStationViewController.h"
#import "EMStationCell.h"
#import "UIViewController+Alert.h"

@interface EMMetroNavigationViewController ()

@property(strong, nonatomic) NSArray* branchesArray;

@property (strong, nonatomic) IBOutlet UITextField *sourceTextField;
@property (strong, nonatomic) IBOutlet UITextField *destinationTextField;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* dfsArray;
@end

@implementation EMMetroNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dfsArray = nil;
    [self branchesSetUp];
    [self transitionsSetUp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.sourceStation != nil && self.destinationStation != nil){
        if([self.sourceStation isEqual:self.destinationStation]){
            NSString* msg = [NSString stringWithFormat:@"Вы начинаете и заканчиваете свой путь на станции %@", self.sourceStation.name];
            [self alertWithTitle:@"Ошибка!" message:msg];
            return;
        }
        self.dfsArray = [self dfs];
        
        if(self.dfsArray == nil){
            [self alertWithTitle:@"Что-то пошло не так..." message:@"Невозможно просчитать маршрут"];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Metro Setup

-(void)branchesSetUp{
    EMBranch* greenBranch = [[EMBranch alloc] initWithColor:EMBranchColorGreen];
    EMBranch* redBranch = [[EMBranch alloc] initWithColor:EMBranchColorRed];
    EMBranch* blueBranch = [[EMBranch alloc] initWithColor:EMBranchColorBlue];
    
    self.branchesArray = @[greenBranch, redBranch, blueBranch];
    
    for(EMBranch* branch in self.branchesArray){
        [self stationsSetUpForBranch:branch];
    }
}

-(void)stationsSetUpForBranch:(EMBranch*) branch{
    
    if(branch.colorValue == EMBranchColorGreen){
        for (NSString* stationName in [EMBranch stationsNameForGreen]){
            [self addStationWithName:stationName toBranch:branch];
        }
    }else if (branch.colorValue == EMBranchColorRed){
        for (NSString* stationName in [EMBranch stationsNameForRed]){
            [self addStationWithName:stationName toBranch:branch];
        }
    }else if (branch.colorValue == EMBranchColorBlue){
        for (NSString* stationName in [EMBranch stationsNameForBlue]){
            [self addStationWithName:stationName toBranch:branch];
        }
    }
}

-(void)addStationWithName:(NSString*)stationName toBranch:(EMBranch*) branch{
    EMStation* station = [[EMStation alloc] initWithName:stationName parentBranch:branch];
    [branch.stationsArray addObject:station];
}

-(void)transitionsSetUp{
    EMBranch* greenBranch = nil;
    EMBranch* redBranch = nil;
    EMBranch* blueBranch = nil;
    
    for(EMBranch* branch in self.branchesArray){
        if(branch.colorValue == EMBranchColorGreen){
            greenBranch = branch;
        }else if (branch.colorValue == EMBranchColorRed){
            redBranch = branch;
        }else if (branch.colorValue == EMBranchColorBlue){
            blueBranch = branch;
        }
    }
    
    for(EMStation* redStation in redBranch.stationsArray){
        if([redStation.name isEqualToString:@"Театральная"]){
            for(EMStation* greenStation in greenBranch.stationsArray){
                if([greenStation.name isEqualToString:@"Золотые ворота"]){
                    redStation.stationTransition = greenStation;
                    greenStation.stationTransition = redStation;
                }
            }
        }else if ([redStation.name isEqualToString:@"Крещатик"]){
            for(EMStation* blueStation in blueBranch.stationsArray){
                if([blueStation.name isEqualToString:@"Площадь Независимости"]){
                    redStation.stationTransition = blueStation;
                    blueStation.stationTransition = redStation;
                }
            }
        }
    }
    
    for(EMStation* blueStation in blueBranch.stationsArray){
        if([blueStation.name isEqualToString:@"Площадь Льва Толстого"]){
            for(EMStation* greenStation in greenBranch.stationsArray){
                if([greenStation.name isEqualToString:@"Дворец спорта"]){
                    blueStation.stationTransition = greenStation;
                    greenStation.stationTransition = blueStation;
                }
            }
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self performSegueWithIdentifier:@"searchStationSegue" sender:textField];
    return NO;
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

-(NSMutableArray*)dfs{
    NSMutableDictionary* dfsDict = [[NSMutableDictionary alloc] init];
    [dfsDict setObject:@1 forKey:self.sourceStation.name];
    
    NSMutableArray* stackS = [[NSMutableArray alloc] init];
    
    [stackS addObject:self.sourceStation];
    
    NSInteger k = 1;
    while (true) {
        if(stackS.count == 0){
            [stackS addObject:self.sourceStation];
            k = k + 1;
        }
        EMStation* stackHead = [stackS lastObject];
        NSInteger stackHeadIndex = [stackHead.parrentBranch.stationsArray indexOfObject:stackHead];
        
        NSMutableArray* ribs = [[NSMutableArray alloc] init];
        
        if(stackHead.parrentBranch.stationsArray.count >= stackHeadIndex+2){
            [ribs addObject:[stackHead.parrentBranch.stationsArray objectAtIndex:stackHeadIndex+1]];
        }
        if(stackHeadIndex > 0){
            [ribs addObject:[stackHead.parrentBranch.stationsArray objectAtIndex:stackHeadIndex-1]];
        }
        if(stackHead.stationTransition){
            [ribs addObject:stackHead.stationTransition];
        }
        
        for(EMStation* station in ribs){
            if([station isEqual:self.destinationStation]){
                k = k + 1;
                [dfsDict setObject:@1 forKey:station.name];
                [stackS addObject:station];
                return stackS;
            }
        }
        
        int counter = 0;
        for(EMStation* station in ribs){
            counter++;
            if(![[dfsDict allKeys] containsObject:station.name]){
                k = k + 1;
                [dfsDict setObject:@1 forKey:station.name];
                [stackS addObject:station];

                break;
            }else if(counter == [ribs count]){
                [stackS removeObject:stackHead];
                k = k - 1;
                break;
            }else{
                continue;
            }
        }
    }
    return nil;
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dfsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EMStationCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[EMStationCell reuseIdentifier]];
    
    EMBranch* currentBranch = [[self.dfsArray objectAtIndex:indexPath.row] parrentBranch];
    EMStation* currentStation = [self.dfsArray objectAtIndex:indexPath.row];
    
    [cell configureWithName:currentStation.name circleColor:[self getColorForBranch:currentBranch]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"searchStationSegue"]){
        EMSelectStationViewController* vc = segue.destinationViewController;
        vc.textField = sender;
        if([sender isEqual:self.sourceTextField]){
            vc.textFieldType = EMTextFieldTypeSource;
        }else{
            vc.textFieldType = EMTextFieldTypeDestination;
        }
        vc.branchesArray = self.branchesArray;
    }
}
@end
