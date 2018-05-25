#import <Foundation/Foundation.h>
#import "../Entities/Country.h"
#import "../Entities/City.h"
#import "../Entities/Airport.h"
#import "../Entities/MapPrice.h"
#import "Ticket.h"
#import "LocationService.h"
#import "NSString+Localize.h"

#define kDataManagerLoadDataComplete @"DataManagerLoadDataCompelete"

typedef enum DataSourceType{
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
} DataSourceType;

@interface DataManager: NSObject

@property (nonatomic, strong, readonly) NSArray* countries;
@property (nonatomic, strong, readonly) NSArray* cities;
@property (nonatomic, strong, readonly) NSArray* airports;

+(instancetype) sharedInstance;
-(void) loadData;
-(City*) cityForIata:(NSString*) iata;
-(City*) cityForLocation:(CLLocation*) location;
@end
