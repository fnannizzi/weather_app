//
//  ViewController.h
//  WeatherApp
//
//  Created by Francesca Nannizzi on 12/4/13.
//  Copyright (c) 2013 Francesca Nannizzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) UITextField *locationField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *controlView;
@property (nonatomic, strong) UIButton *tempFRadioButton;
@property (nonatomic, strong) UILabel *tempFLabel;
@property (nonatomic, strong) UIButton *tempCRadioButton;
@property (nonatomic, strong) UILabel *tempCLabel;

-(void)initiateSearch;
-(void)radiobuttonSelected:(id)sender;

@end
