#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface DataManager()
@property (nonatomic, strong) NSArray* countriesArray;
@property (nonatomic, strong) NSArray* citiesArray;
@property (nonatomic, strong) NSArray* airportsArray;
@end

@implementation DataManager

+(instancetype) sharedInstance{
    static DataManager* dm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[DataManager alloc]init];
    });
    return dm;
}

-(City*) cityForLocation:(CLLocation*) location{
    for (City* city in _citiesArray){
        if (ceilf(city.coordinate.latitude) == ceilf(location.coordinate.latitude)&&
            ceilf(city.coordinate.longitude) == ceilf(location.coordinate.longitude)){
            return city;
        }
    }
    return nil;
}

-(void) loadData{
    dispatch_async (dispatch_get_global_queue(QOS_CLASS_UTILITY, 0 ),^{
        NSArray* countriesFromJSON = [self arrayFromFileName:@"countries" ofType:@"json"];
        self -> _countriesArray = [self createObjectsFromArray:countriesFromJSON withType: DataSourceTypeCountry];
        NSArray* citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        self -> _citiesArray = [self createObjectsFromArray:citiesJsonArray withType: DataSourceTypeCity];
        NSArray* airportsFromJson = [self arrayFromFileName:@"airports" ofType:@"json"];
        self -> _airportsArray = [self createObjectsFromArray:airportsFromJson withType: DataSourceTypeAirport];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataComplete object:nil];
        });
//        ​​​​​​​​​NSLog(@"loading data complete");
    });
}

- ( NSMutableArray*)createObjectsFromArray:( NSArray*)array withType:(DataSourceType)type
{
    NSMutableArray *results = [NSMutableArray new];
    for ( NSDictionary* jsonObject in array) {
        if (type == DataSourceTypeCountry) {
            Country *country = [[Country alloc] initWithDictionary: jsonObject];
            [results addObject: country];
        }
        else if (type == DataSourceTypeCity) {
            City *city = [[City alloc] initWithDictionary: jsonObject];
            [results addObject: city];
        }
        else if (type == DataSourceTypeAirport) {
            Airport *airport = [[Airport alloc] initWithDictionary: jsonObject];
            [results addObject: airport];
        }
    }
    return results;
}

- ( NSArray*)arrayFromFileName:(NSString*) fileName ofType:(NSString*)type{
    NSString* path = [[ NSBundle mainBundle] pathForResource:fileName ofType:type inDirectory:@"DataFiles"];
    NSData* data = [ NSData dataWithContentsOfFile:path];
    @try{
    return [ NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers
                                              error: nil ];
    }
    @catch(NSException * e){
        NSLog(@"%@: %@",[@"error" localize] , e);
    }
}

-(City*) cityForIata:(NSString*) iata{
    if (iata){
        for (City* city in _citiesArray){
            if ([city.code isEqualToString:iata]){
                return city;
            }
        }
    }
    return nil;
}

- ( NSArray *)countries
{
    return _countriesArray;
}
- ( NSArray *)cities
{
    return _citiesArray;
}
- ( NSArray *)airports
{
    return _airportsArray;
}
@end
