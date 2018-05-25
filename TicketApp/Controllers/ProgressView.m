//
//  ProgressView.m
//  TicketApp
//
//  Created by Laptev Sasha on 20/05/2018.
//  Copyright © 2018 Laptev Sasha. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView()
@end

@implementation ProgressView{
    BOOL isActive;
}

+(instancetype)sharedInstance{
    static ProgressView* dm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dm = [[ProgressView alloc]init];
    });
    return dm;
}
-(void)setup{
    UIImageView* backgroundImageView = [[UIImageView alloc]initWithFrame:self.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"cloud"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    [self addSubview:backgroundImageView];
    
    UIVisualEffect* effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
    blurView.frame = self.bounds;
    [self addSubview:blurView];
    
    [self createPlanes];
}

-(void)createPlanes{
    for (int i=0;i<6;i++){
        UIImageView* plane = [[UIImageView alloc]initWithFrame: CGRectMake(-50.0, ((float)i*50.0)+100, 50.0, 50.0)];
        plane.tag = i;
        plane.image = [UIImage imageNamed:@"plane"];
        [self addSubview:plane];
    }
}

-(void)statAnimating:(NSUInteger) planeId{
    if (!isActive)return;
    if (planeId >=6) planeId = 1;
    UIImageView* plane = [self viewWithTag:planeId];
    if (plane){
        [UIView animateWithDuration:1.0 animations:^{
            plane.frame = CGRectMake(self.bounds.size.width, plane.frame.origin.y, 50.0, 50.0);
        } completion:^(BOOL finished) {
            plane.frame = CGRectMake(-50.0, plane.frame.origin.y, 50.0, 50.0);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC),
                       dispatch_get_main_queue (), ^{
                           [self statAnimating: planeId+1];
                       });
    }
}

-(void)show:(void(^)(void))completion{
    self.alpha = 0.0;
    isActive = YES;
    [self statAnimating:1];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
        completion();
    }];
}

-(void)dismiss:(void (^)(void))completion{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha=0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self->isActive = NO;
        if (completion){
            completion();
        }
    }];
}

@end
