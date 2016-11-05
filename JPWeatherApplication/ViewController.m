//
//  ViewController.m
//  JPWeatherApplication
//
//  Created by Kalyani on 21/10/16.
//  Copyright © 2016 jagruti patil. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    forcast = [[NSMutableArray alloc]init];
//    arrayweekdays=[[NSArray alloc]init];
//    arrayweekdays = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"saturday"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startLocating {
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    
    NSLog(@"lattitude = %f",currentLocation.coordinate.latitude);
    
    NSLog(@"longitude = %f",currentLocation.coordinate.longitude);
    
    kLatitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.latitude ];
    kLongitude =[NSString stringWithFormat:@"%f",currentLocation.coordinate.longitude];
    
    [self getweekDaysWeatherDataWithLatitude:kLatitude longitude:kLongitude APIKey:kWeatherAPIKey];
    
    [self getCurrentWeatherDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kWeatherAPIKey];

    
    if (currentLocation !=nil) {
        [locationManager stopUpdatingLocation];
    }
    
    
    //[self getweekDaysWeatherDataWithLatitude:kLatitude longitude:kLongitude APIKey:kWeatherAPIKey];
    
}
-(void)getCurrentWeatherDataWithLatitude:(double)latitude
                               longitude:(double)longitude
                                  APIKey:(NSString *)key{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@",latitude,longitude,key];
    NSLog(@"%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
        }
        else{
            if(response){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200)
                {
                    if (data) {
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if(error){
                            
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                }
            }
        }
    }];
    [task resume];
}
-(void)updateUI:(NSDictionary *)resultDictionary {
    
   // NSLog(@"%@",resultDictionary);
    
    
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"main.temp"]];
    
    
    
    int temp = temperature.intValue;
    
    temperature = [NSString stringWithFormat:@"%d °K",temp];
    
    
    
    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    
    
    NSDictionary *weatherDictionary = weather.firstObject;
    
    
    
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
  //  NSLog(@"%@",condition);
    
    
    NSString *city = [NSString stringWithFormat:@"%@",[resultDictionary valueForKey:@"name"]];
    
    
    self.labelCity.text = city;
    self.labelCondition.text = condition.capitalizedString;
    self.labelTempature.text = temperature;
    
    
}




-(void)getweekDaysWeatherDataWithLatitude:(NSString *)latitude
                             longitude:(NSString *)longitude
                                APIKey:(NSString *)key{
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%@&lon=%@&cnt=7&appid=%@",latitude,longitude,key];
  //  NSLog(@"%@",urlString);
    
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
        }
        else{
            if(response){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200)
                {
                    if (data) {
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if(error){
                            
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUIFor7Days:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                }
            }
        }
    }];
    [task resume];
}
-(void)updateUIFor7Days:(NSDictionary *)resultDictionary{
    NSLog(@"%@",resultDictionary);
    
    list = [resultDictionary valueForKey:@"list"];
   // NSLog(@"%@",list);
    if (forcast.count > 0) {
        [forcast removeAllObjects];
        
    }
    for (NSDictionary *weatherDetail in list) {
        
        
        NSString *max = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.max"]];
        max = [NSString stringWithFormat:@"%d°K",max.intValue];
        NSString *min = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.min"]];
        min = [NSString stringWithFormat:@"%d°K",min.intValue];
        
        
        NSDictionary *myDictionary = @{
                                       @"date" : [NSString stringWithFormat:@"%@",[weatherDetail valueForKey:@"dt"]],
                                       @"maximum_temp" : max,
                                       @"minimum_temp" : min
                                       
                                       };
       // NSLog(@"%@",myDictionary);
        
        [forcast addObject:myDictionary];
        NSLog(@"forcast %@",forcast);
        
        
    }
    
    if (forcast.count > 0) {
    [self.myTableView reloadData];
}
}



- (IBAction)GetCurrentWeather:(id)sender {
    [self startLocating];
    
   // [locationManager startUpdatingLocation];
 //   [self getCurrentWeatherDataWithLatitude:kLatitude.intValue longitude:kLongitude.intValue APIKey:kWeatherAPIKey];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return devices.count;
    
    return forcast.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    forecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forecast_cell"];
 //   cell.labelDays.text =[arrayweekdays objectAtIndex:indexPath.row];
    NSDictionary *temp = [forcast objectAtIndex:indexPath.row];
    
    NSLog(@"%@",temp);
    
    
    NSString *dt = [temp valueForKey:@"date"];
    
    NSTimeInterval time = dt.doubleValue;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    NSString *day = [dateFormatter stringFromDate:date];
    NSLog(@"%@",day);
    
//    cell.labelDays.text = [arrayweekdays objectAtIndex:indexPath.row];
    
    cell.labelDays .text = day;
    //      cell.labelMaxTemperature.text =
    cell.labelMaximumTempature.text =[temp valueForKey:@"maximum_temp"];
    cell.labelMinimumTempature.text = [temp valueForKey:@"minimum_temp"];
    
    

    
    return cell;
}


@end
