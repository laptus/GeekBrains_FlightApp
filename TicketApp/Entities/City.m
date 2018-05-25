//
//  City.m
//  TicketApp
//
//  Created by Laptev Sasha on 08/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "City.h"

@implementation City

-(instancetype) initWithDictionary: (NSDictionary *) dictionary{
    self = [super init];
    if (self)
    {
        _timeZone = [dictionary valueForKey:@"time_zone"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _countryCode = [dictionary valueForKey:@"country_code"];
        _code = [dictionary valueForKey: @"code"];
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
    return  self;
}

@end
