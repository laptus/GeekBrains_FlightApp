#import <Foundation/Foundation.h>

@interface Ticket: NSObject

@property (nonatomic, strong) NSNumber* price;
@property (nonatomic, strong) NSString* airline;
@property (nonatomic, strong) NSDate* departure;
@property (nonatomic, strong) NSDate* expires;
@property (nonatomic, strong) NSNumber* flightNumber;
@property (nonatomic, strong) NSDate* returnDate;
@property (nonatomic, strong) NSString* from;
@property (nonatomic, strong) NSString* t0;

-(instancetype)initWithDictionary: (NSDictionary*) dictionary;

@end
