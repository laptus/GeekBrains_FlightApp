//
//  Airport.h
//  TicketApp
//
//  Created by Laptev Sasha on 08/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <MapKit/MapKit.h>

@interface Airport: NSObject

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* ​timeZone;
@property (nonatomic,strong) NSDictionary* translations;
@property (nonatomic,strong) NSString* ​countryCode;
@property (nonatomic,strong) NSString* ​cityCode;
@property (nonatomic, strong) NSString* code;
@property (nonatomic, getter=isFlightable) BOOL flightable;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(instancetype) initWithDictionary: (NSDictionary *) dictionary;

@end

