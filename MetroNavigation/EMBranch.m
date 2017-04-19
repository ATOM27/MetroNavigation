//
//  Branch.m
//  MetroNavigation
//
//  Created by Eugene Mekhedov on 18.04.17.
//  Copyright © 2017 Eugene Mekhedov. All rights reserved.
//

#import "EMBranch.h"

@implementation EMBranch

- (instancetype)initWithColor:(EMBranchColor)colorValue
{
    self = [super init];
    if (self) {
        self.stationsArray = [[NSMutableArray alloc] init];
        self.colorValue = colorValue;
    }
    return self;
}

#pragma mark - Station names
+(NSArray*)stationsNameForRed{
    NSArray* stationArray = @[@"Академгородок",
                                     @"Житомирская",
                                     @"Святошин",
                                     @"Нивки",
                                     @"Берестейская",
                                     @"Шулявская",
                                     @"Политехнический институт",
                                     @"Вокзальная",
                                     @"Университет",
                                     @"Театральная",
                                     @"Крещатик",
                                     @"Арсенальная",
                                     @"Днепр",
                                     @"Гидропарк",
                                     @"Левобережная",
                                     @"Дарница",
                                     @"Черниговская",
                                     @"Лесная"];
    return stationArray;
}

+(NSArray*)stationsNameForGreen{
    NSArray* stationArray = @[@"Сырец",
                              @"Дорогожичи",
                              @"Лукьяновская",
                              @"Золотые ворота",
                              @"Дворец спорта",
                              @"Кловская",
                              @"Печерская",
                              @"Дружбы Народов",
                              @"Выдубичи",
                              @"Славутич",
                              @"Осокорки",
                              @"Позняки",
                              @"Харьковская",
                              @"Вырлица",
                              @"Бориспольская",
                              @"Красный хутор"];
    return stationArray;
}

+(NSArray*)stationsNameForBlue{
    NSArray* stationArray = @[@"Героев Днепра",
                              @"Минская",
                              @"Оболонь",
                              @"Петровка",
                              @"Тараса Шевченко",
                              @"Контрактовая площадь",
                              @"Почтовая площадь",
                              @"Площадь Независимости",
                              @"Площадь Льва Толстого",
                              @"Олимпийская",
                              @"Дворец Украина",
                              @"Лыбедская",
                              @"Демеевская",
                              @"Голосеевская",
                              @"Васильковская",
                              @"Выставочный центр",
                              @"Ипподром",
                              @"Теремки"];
    return stationArray;
}
@end
