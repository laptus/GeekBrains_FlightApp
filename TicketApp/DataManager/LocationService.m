#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LocationService.h"

@interface LocationService()
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@end

@implementation LocationService
-(instancetype) init{
    self = [super init];
    if (self){
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return self;
}

-(void) locationManager:(CLLocationManager*) manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse){
        [_locationManager  startUpdatingLocation];
    }else if (status != kCLAuthorizationStatusNotDetermined){
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:[@"Oops" localize] message:[@"cant_determine_city" localize] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleDefault handler:nil]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)locationManager:(CLLocationManager*) manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    if (!_currentLocation){
        _currentLocation = [locations firstObject];
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter] postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
    }
}
@end
