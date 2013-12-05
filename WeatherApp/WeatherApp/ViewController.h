//
//  ViewController.h
//  WeatherApp
//
//  Created by Francesca Nannizzi on 12/4/13.
//  Copyright (c) 2013 Francesca Nannizzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate>

// Control components
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic, strong) UITextField *locationField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *tempFRadioButton;
@property (nonatomic, strong) UILabel *tempFLabel;
@property (nonatomic, strong) UIButton *tempCRadioButton;
@property (nonatomic, strong) UILabel *tempCLabel;

// Beginning of URL for weather servlet
@property (nonatomic, strong) NSString *servletURL;

// JSON data
@property (nonatomic, strong) NSDictionary *weather;

// Weather display components
@property (nonatomic, strong) UIView *displayView;
@property (nonatomic, strong) UILabel *cityNameLabel;
@property (nonatomic, strong) UILabel *regionCountryNameLabel;
@property (nonatomic, strong) UILabel *weatherImageLabel;
@property (nonatomic, strong) UILabel *weatherDescriptionLabel;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *forecastTitleLabel;
@property (nonatomic, strong) NSMutableArray *weatherForecastTable;
@property (nonatomic, strong) UIButton *shareCurrentWeatherButton;
@property (nonatomic, strong) UIButton *shareWeatherForecastButton;

-(void)initiateSearch;
-(void)radiobuttonSelected:(id)sender;
-(void)displayForecast;
-(void)displayNoResults;
-(void)buildForecast;
-(void)buildControls;
-(bool)textFieldShouldReturn:(UITextField *)textField;

@end
