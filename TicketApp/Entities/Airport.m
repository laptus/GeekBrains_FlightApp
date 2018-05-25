#import "Airport.h"

@implementation Airport

-(instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self){
        _​timeZone = [dictionary valueForKey:@"time_zone"];
        _name = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _​countryCode = [dictionary valueForKey:@"country_code"];
        _​cityCode = [dictionary valueForKey:@"city_code"];
        _code = [dictionary valueForKey:@"code"];
        _flightable = [dictionary valueForKey:@"flightable"];
        NSDictionary *coords = [dictionary valueForKey:@"coordinates"];
        if(coords && ![coords isEqual:[NSNull null]])
        {
            NSNumber *lon = [coords valueForKey: @"lon"];
            NSNumber *lat = [coords valueForKey: @"lat"];
            if(![lon isEqual:[NSNull null]] && ![lat isEqual:[NSNull null]])
            {
                _coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
            }
        }
        
    }
    return self;
}

@end