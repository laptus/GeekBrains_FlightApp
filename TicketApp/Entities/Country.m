//
//  Country.m
//  TicketApp
//
//  Created by Laptev Sasha on 08/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Country.h"

@implementation Country
-(instancetype) initWithDictionary: (NSDictionary *) dictionary{
    self = [super init];
    if (self){
        _currency = [dictionary valueForKey:@"currency"];
        _translations = [dictionary valueForKey:@"name_translations"];
        _name = [dictionary valueForKey:@"name"];
        _code = [dictionary valueForKey:@"code"];
    }
    return self;
}
@end
