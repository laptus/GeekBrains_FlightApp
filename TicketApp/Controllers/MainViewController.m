//
//  ViewController.m
//  TicketApp
//
//  Created by Laptev Sasha on 08/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import "MainViewController.h"
#import "../Entities/Structures.h"

@interface MainViewController ()
@property (nonatomic,strong) UIView* placeViewContainerView;
@property (nonatomic,strong) UIButton* departureButton;
@property (nonatomic,strong) UIButton* arriveButton;
@property (nonatomic,strong) UIButton* searchButton;
@property (nonatomic,strong) UIButton* mapButton;
@property (nonatomic) SearchRequest searchRequest;
@end

@implementation MainViewController

-(void) viewDidAppear:(BOOL)animated{
    [ super viewDidAppear :animated];
    [ self presentFirstViewControllerIfNeeded ];
}

- ( void )presentFirstViewControllerIfNeeded
{
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey : @"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc]
                                                    initWithTransitionStyle : UIPageViewControllerTransitionStyleScroll
                                                    navigationOrientation : UIPageViewControllerNavigationOrientationHorizontal options : nil ];
        [self presentViewController :firstViewController animated : YES completion : nil ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DataManager sharedInstance] loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadDataComplete) name:kDataManagerLoadDataComplete object:nil];
    
//    self.navigationController.navigationBar.prefersLargeTitles = YES;
    self.title = [@"search" localize];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _placeViewContainerView = [[UIView alloc] initWithFrame: CGRectMake(20, 100, [UIScreen mainScreen].bounds.size.width - 40, 170)];
    _placeViewContainerView.backgroundColor = [UIColor whiteColor];
    _placeViewContainerView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
    _placeViewContainerView.layer.shadowOffset = CGSizeZero;
    _placeViewContainerView.layer.shadowRadius = 1.0;
    _placeViewContainerView.layer.cornerRadius = 6.0;
    [self.view addSubview:_placeViewContainerView];
    
    _departureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_departureButton setTitle:[@"from" localize] forState:UIControlStateNormal];
    _departureButton.tintColor = [UIColor blackColor];
    _departureButton.frame = CGRectMake(CGRectGetMinX(_placeViewContainerView.frame) + 5,
                                        CGRectGetMinY(_placeViewContainerView.frame) + 5,
                                        _placeViewContainerView.frame.size.width - 10.0,
                                        _placeViewContainerView.frame.size.height/2.0 - 10.0);
    _departureButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    [_departureButton addTarget:self action:@selector(placeButtomDidTap:) forControlEvents:UIControlEventTouchUpInside];
    _departureButton.layer.cornerRadius = 4;
    [self.view addSubview:_departureButton];
    
    _arriveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_arriveButton setTitle:[@"to" localize]  forState:UIControlStateNormal];
    _arriveButton.tintColor = [UIColor blackColor];
    _arriveButton.frame = CGRectMake(CGRectGetMinX(_departureButton.frame),
                                     CGRectGetMaxY(_departureButton.frame) + 10,
                                     _placeViewContainerView.frame.size.width - 10.0,
                                     _placeViewContainerView.frame.size.height/2.0 - 10.0);
    _arriveButton.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    _arriveButton.layer.cornerRadius = 4;
    [_arriveButton addTarget:self action:@selector(placeButtomDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_arriveButton];
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_searchButton setTitle:[@"find" localize]  forState:UIControlStateNormal];
    _searchButton.tintColor = [UIColor whiteColor];
    _searchButton.frame = CGRectMake(CGRectGetMinX(_placeViewContainerView.frame),
                                     CGRectGetMaxY(_placeViewContainerView.frame) + 30,
                                     _placeViewContainerView.frame.size.width ,
                                     60);
    _searchButton.backgroundColor = [UIColor blackColor];
    _searchButton.layer.cornerRadius = 8;
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [_searchButton addTarget:self action:@selector(searchButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_searchButton];
}

-(void)mapButtonDidTap{
    MapViewController* mapViewCntrl = [[MapViewController alloc] init];
    [self.navigationController pushViewController:mapViewCntrl animated:YES];
}

-(void) placeButtomDidTap: (UIButton*) sender{
    PlaceViewController* placeCntrl;
    if ([sender isEqual:_departureButton]){
        placeCntrl = [[PlaceViewController alloc] initWithType:PlaceTypeDeparture];
    }else{
        placeCntrl = [[PlaceViewController alloc] initWithType:PlaceTypeArrival];
    }
    placeCntrl.delegate = self;
    [self.navigationController pushViewController:placeCntrl animated:YES];
}

-(void) selectPlace: (id) place withType: (PlaceType) placeType andDataType:(DataSourceType) dataType{
    [self selectPlace:place withType:placeType andDataType:dataType forButton:(placeType == PlaceTypeDeparture) ? _departureButton : _arriveButton ];
}

-(void) searchButtonDidTap:(UIButton*) sender{
    if (_searchRequest.origin && _searchRequest.destination){
        [[ProgressView sharedInstance] show:^{
            [[ApiManager sharedInstance] ticketsWithRequest:self->_searchRequest withCompletion:^(NSArray *tickets) {
                if (tickets.count > 0){
                    TicketsViewController* ticketsViewController = [[TicketsViewController alloc] initWithTickets:tickets];
                    [self.navigationController showViewController:ticketsViewController sender:nil];
                }else{
                    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:[@"Oops" localize] message:[@"no_tickets" localize] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }];
    } else{
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:[@"error" localize] message:[@"destination_departure_needed" localize] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:[@"error" localize] style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

-(void) selectPlace: (id) place withType: (PlaceType) placeType andDataType:(DataSourceType) dataType forButton: (UIButton*) button{
    NSString* title;
    NSString* data;
    if (dataType == DataSourceTypeCity){
        title = ((City*)place).name;
        data = ((City*)place).code;
    }
    else if (dataType == DataSourceTypeAirport){
        title = ((Airport*)place).name;
        data = ((Airport*)place).​cityCode;
    }
    
    if (placeType == PlaceTypeDeparture){
        _searchRequest.origin=data;
    }else{
        _searchRequest.destination = data;
    }
    [button setTitle:title forState:UIControlStateNormal];
}

- (void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataComplete object:nil];
}

-(void) loadDataComplete{
    [[ApiManager sharedInstance] cityForCurrentIP:^(City *city) {
        [self selectPlace:city withType:DataSourceTypeCity andDataType:PlaceTypeDeparture forButton:self->_departureButton];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
