#import "TicketTableViewCell.h"
#import <YYWebImage/YYWebImage.h>
#define AirLineLogo(iata) [NSURL URLWithString:[NSString stringWithFormat:@"https://pics.avis.io/200/200/%@.png", iata]];


@interface TicketTableViewCell()

@property (nonatomic, strong) UILabel* priceLabel;
@property (nonatomic, strong) UILabel* placesLabel;
@property (nonatomic, strong) UILabel* dateLabel;
@end

@implementation TicketTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.contentView.layer.shadowColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2]CGColor];
        self.contentView.layer.shadowOffset = CGSizeMake(1.0,1.0);
        self.contentView.layer.shadowRadius = 10;
        self.contentView.layer.shadowOpacity = 1;
        self.contentView.layer.cornerRadius = 6;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_priceLabel];
        
        _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
        _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_airlineLogoView];
        
        _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
        _placesLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_placesLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];
        [self.contentView addSubview:_dateLabel];
    }
    return self;
}

-(void) layoutSubviews{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(10.0, 10.0,
                                        [UIScreen mainScreen].bounds.size.width - 20,
                                        self.frame.size.height - 20);
    _priceLabel.frame = CGRectMake(10, 10, self.contentView.frame.size.width - 110.0, 40);
    _airlineLogoView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+10.0,10. , 80.0, 80.0);
    _placesLabel.frame = CGRectMake(10, CGRectGetMaxY(_priceLabel.frame)+16.0, 100.0, 20);
    _dateLabel.frame = CGRectMake(10, CGRectGetMaxY(_placesLabel.frame) + 8.0,
                                  self.contentView.frame.size.width - 20.0, 20.0);
}

-(void)setFavoriteTicket:(Ticket *)favoriteTicket{
    _favoriteTicket = favoriteTicket;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@ %@", [favoriteTicket valueForKey:@"price"], [@"from" localize]];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", [favoriteTicket valueForKey:@"from"], [favoriteTicket valueForKey:@"to"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:[favoriteTicket valueForKey:@"departure"]];
    NSURL *urlLogo = AirLineLogo(favoriteTicket.airline);
    [_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
    
}

-(void)setTicket:(Ticket*) ticket{
    _ticket = ticket;
    _priceLabel.text = [NSString stringWithFormat:@"%@,%@", _ticket.price ,[@"rub" localize]];
    _placesLabel.text = [NSString stringWithFormat:@"%@ - %@", _ticket.from, _ticket.t0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _dateLabel.text = [dateFormatter stringFromDate:_ticket.departure];
    
    NSURL* urlLogo = AirLineLogo(ticket.airline);
    [_airlineLogoView yy_setImageWithURL:urlLogo options:YYWebImageOptionSetImageWithFadeAnimation];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
