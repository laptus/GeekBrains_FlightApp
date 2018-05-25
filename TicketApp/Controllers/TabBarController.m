#import "TabBarController.h"
#import "MainViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

-(instancetype)init{
    self = [super initWithNibName:nil bundle:nil];
    if (self){
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
    }
    return self;
}

-(NSArray<UIViewController*>*) createViewControllers{
    NSMutableArray<UIViewController*>* controllers = [NSMutableArray new];
    MainViewController* mainCtrl  = [[MainViewController alloc] init];
    mainCtrl.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"search" localize] image: [UIImage imageNamed: @"search"] selectedImage:[UIImage imageNamed: @"search_selected"]];
    UINavigationController* mainNavigationCtrl = [[UINavigationController alloc] initWithRootViewController:mainCtrl];
    [controllers addObject:mainNavigationCtrl];
    
    MapViewController* mapController = [[MapViewController alloc] init];
    mapController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"map" localize] image: [UIImage imageNamed: @"map"] selectedImage:[UIImage imageNamed: @"map_selected"]];
    UINavigationController* mapNavigationCtrl = [[UINavigationController alloc] initWithRootViewController:mapController];
    [controllers addObject:mapNavigationCtrl];
    
    TicketsViewController* favoriteViewController = [[TicketsViewController alloc] initFavoriteTicketController];
    favoriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:[@"favourites" localize] image:[UIImage imageNamed: @"favorite"] selectedImage:[UIImage imageNamed: @"favorite_selected"]];
    [controllers addObject:favoriteViewController];
    
    return controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
