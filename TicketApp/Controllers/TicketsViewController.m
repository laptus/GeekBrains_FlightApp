#import "TicketsViewController.h"
#define TicketCellReuseIdentifier @"TicketCellIdentifier"
#import "../DataManager/CoreDateHelper.h"

@interface TicketsViewController ()
@property (nonatomic, strong) NSArray* tickets;
@property (nonatomic, strong) UIDatePicker* datePicker;
@property (nonatomic, strong) UITextField* dateTextField;
@end

@implementation TicketsViewController{
    BOOL isFavorites;
    TicketTableViewCell* notificationCell;
}

-(instancetype) initFavoriteTicketController{
    self = [super init];
    if (self){
        isFavorites = YES;
        self.title = [@"favourites" localize];
        self.tickets = [NSArray new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
    }
    return self;
}

-(instancetype) initWithTickets:(NSArray *)tickets{
    self = [super init];
    if (self){
        _tickets = tickets;
        self.title = [@"tickets" localize];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[TicketTableViewCell class] forCellReuseIdentifier:TicketCellReuseIdentifier];
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime ;
        _datePicker.minimumDate = [NSDate date];
        _dateTextField = [[UITextField alloc] initWithFrame: self.view.bounds];
        _dateTextField.hidden = YES;
        _dateTextField.inputView = _datePicker;
        
        UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doneButtonDidTap:)];
        keyboardToolbar.items = @[flexBarButton, doneBarButton];
        _dateTextField.inputAccessoryView = keyboardToolbar;
        [self.view addSubview: _dateTextField];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (isFavorites){
        self.navigationController.navigationBar.prefersLargeTitles = YES;
        _tickets = [[CoreDataHelper sharedInstance] favorites];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketCellReuseIdentifier forIndexPath:indexPath];
    if (isFavorites){
        cell.favoriteTicket =  [_tickets objectAtIndex: indexPath.row];;
    }else{
        cell.ticket = [_tickets objectAtIndex: indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isFavorites) return;
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:[@"actions" localize] message:[@"what_to_do_with_ticket" localize]  preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* favoriteAction;
    if ([[CoreDataHelper sharedInstance] isFavorite:[_tickets objectAtIndex:indexPath.row]]){
        favoriteAction = [UIAlertAction actionWithTitle:[@"delete" localize] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] removeFromFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }else{
        favoriteAction =[UIAlertAction actionWithTitle:[@"add" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[CoreDataHelper sharedInstance] addToFavorite:[self->_tickets objectAtIndex:indexPath.row]];
        }];
    }
    
    UIAlertAction* notificationlAction = [UIAlertAction actionWithTitle:[@"remember" localize] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        notificationCell = [tableView cellForRowAtIndexPath:indexPath];
        [_dateTextField becomeFirstResponder];
    }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:[@"close" localize] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:notificationlAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)doneButtonDidTap:( UIBarButtonItem *)sender{
    if (_datePicker.date && notificationCell){
        NSString* message = [NSString stringWithFormat:@"%@ - %@ за %@ %@",
        notificationCell.ticket.from, notificationCell.ticket.t0, notificationCell.ticket.price, [@"rub" localize]];
        NSURL* imageUrl;
        if(notificationCell.airlineLogoView.image){
            NSString *path = [[ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/%@.png" , notificationCell.ticket.airline]];
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
                UIImage* logo = notificationCell.airlineLogoView.image;
                NSData* pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
            }
            imageUrl = [NSURL fileURLWithPath:path];
        }
        
        Notification notification = NotificationMake(@"Ticket reminder", message, _datePicker.date, imageUrl);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        
        UIAlertController *alertController = [ UIAlertController alertControllerWithTitle : [@"success" localize] message:[NSString stringWithFormat: @"%@ - %@", [@"notification_will_be_sent_on" localize] ,_datePicker.date] preferredStyle:( UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle: [@"close" localize] style:UIAlertActionStyleCancel handler: nil];
        [alertController addAction: cancelAction];
        [self presentViewController: alertController animated: YES completion: nil ];
    }
    _datePicker.date =[NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}
@end
