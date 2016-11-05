//
//  forecastTableViewCell.h
//  JPWeatherApplication
//
//  Created by Kalyani on 21/10/16.
//  Copyright © 2016 jagruti patil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface forecastTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelDays;
@property (strong, nonatomic) IBOutlet UILabel *labelMaximumTempature;
@property (strong, nonatomic) IBOutlet UILabel *labelMinimumTempature;

@end
