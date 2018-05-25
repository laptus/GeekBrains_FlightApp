#import "MapViewController.h"


@interface MapViewController ()<MKMapViewDelegate>
@property (nonatomic,strong) MKMapView* mapView;
@property (nonatomic,strong) LocationService* locationService;
@property (nonatomic,strong) City* origin;
@property (nonatomic,strong) NSArray* prices;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [@"price_map" localize] ;
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    [[DataManager sharedInstance] loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadedSuccessfully) name:kDataManagerLoadDataComplete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCurrentLocation:) name:kLocationServiceDidUpdateCurrentLocation object:nil];
}

-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)dataLoadedSuccessfully{
    _locationService = [[LocationService alloc] init];
}

-(void)updateCurrentLocation:(NSNotification*)notification{
    CLLocation* currentLocation = notification.object;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 1000000, 1000000);
    [_mapView setRegion:region animated:YES];
    
    if (currentLocation){
        _origin = [[DataManager sharedInstance] cityForLocation:currentLocation];
        if (_origin){
            [[ApiManager sharedInstance] mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }
}

-(void)setPrices:(NSArray *)prices{
    _prices = prices;
    [_mapView removeAnnotations:_mapView.annotations];
    for(MapPrice* price in prices){
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name, price.destination.code];
            annotation.subtitle = [NSString stringWithFormat:@"%ld %@", (long)price.value,[@"rub" localize] ];
            annotation.coordinate = price.destination.coordinate;
            [_mapView addAnnotation:annotation];
        });
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
