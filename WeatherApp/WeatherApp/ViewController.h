//
//  ViewController.h
//  WeatherApp
//
//  Created by Francesca Nannizzi on 12/4/13.
//  Copyright (c) 2013 Francesca Nannizzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextViewDelegate, UIAlertViewDelegate>

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

// Facebook post components
@property bool sharingCurrentWeather;
@property bool sharingWeatherForecast;
@property (nonatomic, strong) NSString *postTitle;
@property (nonatomic, strong) NSString *postCaptionCurrentWeather;
@property (nonatomic, strong) NSString *postCaptionWeatherForecast;
@property (nonatomic, strong) NSString *postDescriptionCurrentWeather;
@property (nonatomic, strong) NSString *postDescriptionWeatherForecast;
@property (nonatomic, strong) NSString *postLink;
@property (nonatomic, strong) NSString *postImage;

-(void)initiateSearch;
-(void)radiobuttonSelected:(id)sender;
-(void)displayForecast;
-(void)displayNoResults;
-(void)buildForecast;
-(void)buildControls;
-(bool)textFieldShouldReturn:(UITextField *)textField;
-(bool) isNumeric:(NSString*) checkText;
-(void)shareCurrentWeather;
-(void)shareWeatherForecast;
-(void)facebookLogin;
-(NSDictionary*)parseURLParams:(NSString *)query;

@end
