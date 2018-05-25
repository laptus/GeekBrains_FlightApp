//
//  ProgressView.h
//  TicketApp
//
//  Created by Laptev Sasha on 20/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+(instancetype) sharedInstance;
-(void) show:(void(^)(void))completion;
-(void) dismiss:(void(^)(void))completion;

@end
