//
//  ViewController.m
//  WeatherApp
//
//  Created by Francesca Nannizzi on 12/4/13.
//  Copyright (c) 2013 Francesca Nannizzi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    // Add background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bluesky.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Set up a view to add control components to
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 400, 400)];
    
    // Add location text field
    // CGRectMake(x, y, width, height)
    self.locationField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, 150, 30)];
    self.locationField.textColor = [UIColor grayColor];
    self.locationField.font = [UIFont fontWithName:@"Helvetica" size:14];
    self.locationField.backgroundColor=[UIColor whiteColor];
    self.locationField.placeholder = @"Zip or Location";
    self.locationField.textAlignment = NSTextAlignmentLeft;
    [self.locationField.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.locationField.layer setBorderWidth:1.0];
    // Add the text field to the control view
    [self.controlView addSubview:self.locationField];
    
    // Add Fahrenheit button label
    self.tempFLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(165, 60, 10, 30) ];
    //self.tempFLabel.textAlignment =  UITextAlignment;
    self.tempFLabel.textColor = [UIColor blackColor];
    self.tempFLabel.text = [NSString stringWithFormat: @"F"];
    self.tempFLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.controlView addSubview:self.tempFLabel];

    
    // Add Fahrenheit radio button
    self.tempFRadioButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tempFRadioButton.frame = CGRectMake(180, 65, 20, 20);
    [self.tempFRadioButton setTag:0];
    [self.tempFRadioButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [self.tempFRadioButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [self.tempFRadioButton addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.tempFRadioButton setSelected:YES];
    // Add button to control view
    [self.controlView addSubview:self.tempFRadioButton];
    
    // Add Celsius button label
    self.tempCLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(205, 60, 10, 30) ];
    //self.tempFLabel.textAlignment =  UITextAlignment;
    self.tempCLabel.textColor = [UIColor blackColor];
    self.tempCLabel.text = [NSString stringWithFormat: @"C"];
    self.tempCLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
    [self.controlView addSubview:self.tempCLabel];
    
    
    // Add Celsius radio button
    self.tempCRadioButton = [[UIButton alloc] initWithFrame:CGRectMake(220, 65, 20, 20)];
    [self.tempCRadioButton setTag:1];
    [self.tempCRadioButton setBackgroundImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
    [self.tempCRadioButton setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [self.tempCRadioButton addTarget:self action:@selector(radiobuttonSelected:) forControlEvents:UIControlEventTouchUpInside];
    [self.tempCRadioButton setSelected:NO];
    // Add button to control view
    [self.controlView addSubview:self.tempCRadioButton];
    
    
    // Add search button
    self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.searchButton addTarget:self action:@selector(initiateSearch) forControlEvents:UIControlEventTouchDown];
    [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
    self.searchButton.backgroundColor = [UIColor whiteColor];
    self.searchButton.frame = CGRectMake(250, 60, 60, 30);
    // Add the search button to the control view
    [self.controlView addSubview:self.searchButton];

    // Add the control view to the main view
    [self.view addSubview:self.controlView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initiateSearch
{
    NSLog(@"Beginning location search on %@", self.locationField.text);
}

-(void)radiobuttonSelected:(id)sender
{
    switch ([sender tag]) {
        case 0:
            if([self.tempFRadioButton isSelected]==YES)
            {
                [self.tempFRadioButton setSelected:NO];
                [self.tempCRadioButton setSelected:YES];
                NSLog(@"Temperature set to Celsius.");
            }
            else{
                [self.tempFRadioButton setSelected:YES];
                [self.tempCRadioButton setSelected:NO];
                NSLog(@"Temperature set to Fahrenheit.");
            }
            break;
        case 1:
            if([self.tempCRadioButton isSelected]==YES)
            {
                [self.tempCRadioButton setSelected:NO];
                [self.tempFRadioButton setSelected:YES];
                NSLog(@"Temperature set to Fahrenheit.");
            }
            else{
                [self.tempCRadioButton setSelected:YES];
                [self.tempFRadioButton setSelected:NO];
                NSLog(@"Temperature set to Celsius.");
            }
            break;
        default:
            break;
    }
}

@end
