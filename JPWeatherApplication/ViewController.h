//
//  ViewController.h
//  JPWeatherApplication
//
//  Created by Kalyani on 21/10/16.
//  Copyright © 2016 jagruti patil. All rights reserved.
//
#define kWeatherAPIKey @"5e178f5e8e3178ab1b2495367a02c54a"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "forecastTableViewCell.h"
@interface ViewController :UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
NSArray *list;
NSMutableArray *forcast;
NSString *kLatitude;
NSString *kLongitude;
CLLocationManager *locationManager;
NSString *maxTemperature;
//NSMutableArray *myArray;
NSDictionary *maxTemp;
//    NSArray *arrayweekdays;
}


@property (strong, nonatomic) IBOutlet UILabel *labelCity;
@property (strong, nonatomic) IBOutlet UILabel *labelCondition;
@property (strong, nonatomic) IBOutlet UILabel *labelTempature;

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)GetCurrentWeather:(id)sender;

@end

