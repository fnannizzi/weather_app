//
//  ViewController.m
//  WeatherApp
//
//  Created by Francesca Nannizzi on 12/4/13.
//  Copyright (c) 2013 Francesca Nannizzi. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController


-(void)confirmShareCurrentWeather
{
    
    self.sharingCurrentWeather = true;
    self.sharingWeatherForecast = false;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post to Facebook" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Post Current Weather",nil];
    [alert show];
}

-(void)confirmShareWeatherForecast
{
    self.sharingCurrentWeather = false;
    self.sharingWeatherForecast = true;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post to Facebook" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Post Weather Forecast",nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"User cancelled posting.");
    }
    else if (buttonIndex == 1) {
        NSLog(@"User is posting to facebook.");
        if(self.sharingCurrentWeather)
            [self shareCurrentWeather];
        else if(self.sharingWeatherForecast)
            [self shareWeatherForecast];
    }
}

-(void)shareCurrentWeather
{
    [self facebookLogin];
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.postTitle, @"name",
     self.postCaptionCurrentWeather, @"caption",
     self.postDescriptionCurrentWeather, @"description",
     self.postLink, @"link",
     self.postImage, @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
}


-(void)shareWeatherForecast
{
    [self facebookLogin];
    
    // Put together the dialog parameters
    NSMutableDictionary *params =
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     self.postTitle, @"name",
     self.postCaptionWeatherForecast, @"caption",
     self.postDescriptionWeatherForecast, @"description",
     self.postLink, @"link",
     self.postImage, @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"Result"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"OK!"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)facebookLogin
{
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        //[appDelegate.session closeAndClearTokenInformation];
        
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
        }];
    }
}

-(void)initiateSearch
{
    bool isZipCode = false;
    bool isCity = false;
    
    NSError *REError = NULL;
    self.regex = [NSRegularExpression regularExpressionWithPattern:@"^[A-Za-z]+[ ]*[A-Za-z]*,[ ]?[A-Za-z]{2,}(,[ ]?[A-Za-z]{2,})?$" options:0 error:&REError];
    
    NSString *locationStr = self.locationField.text;
    
    if([locationStr length] < 1){
        NSLog(@"Aborting search on null location string.");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a city name or zip code." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        return;
    }
    if([self isNumeric:locationStr]){
        if([locationStr length] != 5){
            NSLog(@"Aborting search on incorrect zip code.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Are you searching for a zip code? Make sure to include 5 numbers." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else {
            NSLog(@"Location is a zip code.");
            isZipCode = true;
        }
    }
    else {
        NSTextCheckingResult *match = [self.regex firstMatchInString:locationStr options:0 range:NSMakeRange(0, [locationStr length])];
        if(!match){
            NSLog(@"Aborting search on incorrect city name.");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Are you searching for a city? Make sure to give the city name, followed by a comma and the city's state or country." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            return;
        }
        else {
            NSLog(@"Location is a city.");
            isCity = true;
        }
    }
    
    
    self.servletURL = @"http://cs-server.usc.edu:65223/examples/servlet/weathersearch?location=";
    NSLog(@"Beginning location search on %@.", self.locationField.text);
    
    NSString *weatherURLStr;
    if(isCity){
        if([self.tempFRadioButton isSelected]==YES)
            weatherURLStr = [NSString stringWithFormat:@"%@%@%@", self.servletURL, locationStr, @"&type=city&tempUnit=f"];
        else
            weatherURLStr = [NSString stringWithFormat:@"%@%@%@", self.servletURL, locationStr, @"&type=city&tempUnit=c"];
    }
    else if(isZipCode){
        if([self.tempFRadioButton isSelected]==YES)
            weatherURLStr = [NSString stringWithFormat:@"%@%@%@", self.servletURL, locationStr, @"&type=zip&tempUnit=f"];
        else
            weatherURLStr = [NSString stringWithFormat:@"%@%@%@", self.servletURL, locationStr, @"&type=zip&tempUnit=c"];
    }
    
    NSURL *weatherURL = [NSURL URLWithString:[weatherURLStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *weatherData = [[NSData alloc] initWithContentsOfURL:weatherURL];
    NSError *error;
    self.weather = [NSJSONSerialization JSONObjectWithData:weatherData options:NSJSONReadingMutableContainers error:&error][@"weather"];
	
    if(error){
        NSLog(@"Error loading JSON: %@", [error localizedDescription]);
    }
    else {
        if(self.weather){
            NSLog(@"JSON data loaded.");
            NSLog(@"%@", self.weather);
            [self displayForecast];
        }
        else {
            NSLog(@"No results found for %@.", self.locationField.text);
            [self displayNoResults];
        }
    }
}

-(void)displayForecast
{
    NSLog(@"Preparing to display forecast data for %@", self.locationField.text);
    
    // Set city name label
    NSString *cityNameText = [NSString stringWithFormat: @"%@", [[self.weather objectForKey:@"location"] objectForKey:@"city"]];
    if([cityNameText length] > 0)
        self.cityNameLabel.text = cityNameText;
    else
        self.cityNameLabel.text = @"";
    
    // Set country and region name label
    NSString *regionNameText = [NSString stringWithFormat: @"%@", [[self.weather objectForKey:@"location"] objectForKey:@"region"]];
    NSString *countryNameText = [NSString stringWithFormat: @"%@", [[self.weather objectForKey:@"location"] objectForKey:@"country"]];
    if(([regionNameText length] > 0) && ([countryNameText length] > 0))
        self.regionCountryNameLabel.text = [NSString stringWithFormat: @"%@, %@", regionNameText, countryNameText];
    else if([regionNameText length] > 0)
        self.regionCountryNameLabel.text = [NSString stringWithFormat: @"%@", regionNameText];
    else if([countryNameText length] > 0)
        self.regionCountryNameLabel.text = [NSString stringWithFormat: @"%@", countryNameText];
    
    // Set weather image label
    NSString *weatherImageText = [NSString stringWithFormat: @"%@", [self.weather objectForKey:@"img"]];
    if([weatherImageText length] > 0){
        NSURL *weatherImageURL = [NSURL URLWithString:[weatherImageText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        self.weatherImageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:weatherImageURL]]];
    }
    else
        self.weatherImageLabel.backgroundColor = [UIColor clearColor];
    
    // Set weather description label
    NSString *weatherDescriptionText = [NSString stringWithFormat:@"%@", [[self.weather objectForKey:@"condition"] objectForKey:@"text"]];
    if([weatherDescriptionText length] > 0)
        self.weatherDescriptionLabel.text = weatherDescriptionText;
    else
        self.weatherDescriptionLabel.text = @"";
    
    // Set temperature label
    NSString *temperatureText = [NSString stringWithFormat:@"%@", [[self.weather objectForKey:@"condition"] objectForKey:@"temp"]];
    if([temperatureText length] > 0)
        self.temperatureLabel.text = [NSString stringWithFormat:@"%@%@", temperatureText, @"\u00B0"];
    else
        self.temperatureLabel.text = @"";
    
    // Set forecast title label
    self.forecastTitleLabel.text = @"Forecast";
    
    // Set weather forecast table (and also fill out description string)
    for(int rows = 0; rows < 6; rows++){
        for(int cols = 0; cols < 4; cols++){
            UILabel *label = [self.weatherForecastTable objectAtIndex:((rows*4)+cols)];
            if(rows == 0){
                label.backgroundColor = [UIColor grayColor];
                if(cols == 0)
                    label.text = @"Day";
                else if(cols == 1)
                    label.text = @"Weather";
                else if(cols == 2)
                    label.text = @"High";
                else if(cols == 3)
                    label.text = @"Low";
            }
            else {
                NSDictionary *forecast = [self.weather objectForKey:@"forecast"][rows - 1];
                label.backgroundColor = [UIColor whiteColor];
                if(cols == 0)
                    label.text = [NSString stringWithFormat:@"%@", [forecast objectForKey:@"Day"]];
                else if(cols == 1)
                    label.text = [NSString stringWithFormat:@"%@", [forecast objectForKey:@"Weather"]];
                else if(cols == 2)
                    label.text = [NSString stringWithFormat:@"%@", [forecast objectForKey:@"High"]];
                else if(cols == 3)
                    label.text = [NSString stringWithFormat:@"%@", [forecast objectForKey:@"Low"]];
            }
        }
    }
    
    // Set share current weather button
    [self.shareCurrentWeatherButton setTitle:@"Share Current Weather" forState:UIControlStateNormal];
    self.shareCurrentWeatherButton.enabled = YES;
    
    // Set share weather forecast button
    [self.shareWeatherForecastButton setTitle:@"Share Weather Forecast" forState:UIControlStateNormal];
    self.shareWeatherForecastButton.enabled = YES;
    
    // Save some data for later in case the user would like to post to Facebook
    self.postTitle = [NSString stringWithFormat:@"%@, %@", cityNameText, self.regionCountryNameLabel.text];
    self.postCaptionCurrentWeather = [NSString stringWithFormat:@"The current condition for %@ is %@.", cityNameText, weatherDescriptionText];
    self.postCaptionWeatherForecast = [NSString stringWithFormat:@"Weather Forecast for %@", cityNameText];
    self.postImage = weatherImageText;
    self.postLink = [NSString stringWithFormat:@"%@", [self.weather objectForKey:@"link"]];
    self.postDescriptionCurrentWeather = [NSString stringWithFormat:@"Temperature is %@%@.", temperatureText, @"\u00B0"];
    self.postDescriptionWeatherForecast = [NSString stringWithFormat:@"%@, %@, %@/%@. %@, %@, %@/%@. %@, %@, %@/%@. %@, %@, %@/%@. %@, %@, %@/%@.", [[self.weather objectForKey:@"forecast"][0] objectForKey:@"Day"], [[self.weather objectForKey:@"forecast"][0] objectForKey:@"Weather"], [[self.weather objectForKey:@"forecast"][0] objectForKey:@"High"], [[self.weather objectForKey:@"forecast"][0] objectForKey:@"Low"],
        [[self.weather objectForKey:@"forecast"][1] objectForKey:@"Day"], [[self.weather objectForKey:@"forecast"][1] objectForKey:@"Weather"],[[self.weather objectForKey:@"forecast"][1] objectForKey:@"High"], [[self.weather objectForKey:@"forecast"][1] objectForKey:@"Low"], [[self.weather objectForKey:@"forecast"][2] objectForKey:@"Day"], [[self.weather objectForKey:@"forecast"][2] objectForKey:@"Weather"], [[self.weather objectForKey:@"forecast"][2] objectForKey:@"High"], [[self.weather objectForKey:@"forecast"][2] objectForKey:@"Low"], [[self.weather objectForKey:@"forecast"][3] objectForKey:@"Day"], [[self.weather objectForKey:@"forecast"][3] objectForKey:@"Weather"], [[self.weather objectForKey:@"forecast"][3] objectForKey:@"High"], [[self.weather objectForKey:@"forecast"][3] objectForKey:@"Low"], [[self.weather objectForKey:@"forecast"][4] objectForKey:@"Day"], [[self.weather objectForKey:@"forecast"][4] objectForKey:@"Weather"], [[self.weather objectForKey:@"forecast"][4] objectForKey:@"High"], [[self.weather objectForKey:@"forecast"][4] objectForKey:@"Low"]];
}

-(void)displayNoResults
{
    self.cityNameLabel.text = @"No results found!";
    self.regionCountryNameLabel.text = @"";
    self.weatherImageLabel.backgroundColor = [UIColor clearColor];
    self.weatherDescriptionLabel.text = @"";
    self.temperatureLabel.text = @"";
    self.forecastTitleLabel.text = @"";
    
    // Set weather forecast table
    for(int rows = 0; rows < 6; rows++){
        for(int cols = 0; cols < 4; cols++){
            UILabel *label = [self.weatherForecastTable objectAtIndex:((rows*4)+cols)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"";
        }
    }
    
    [self.shareCurrentWeatherButton setTitle:@"" forState:UIControlStateNormal];
    self.shareCurrentWeatherButton.enabled = NO;
    [self.shareWeatherForecastButton setTitle:@"" forState:UIControlStateNormal];
    self.shareWeatherForecastButton.enabled = NO;
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
    NSString *locationStr = self.locationField.text;
    
    if([locationStr length] > 1)
        [self initiateSearch];
}

-(void)buildForecast
{
    NSLog(@"Preparing to build forecast components.");
    
    // Create a display view to add components to
    self.displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.screenWidth, 400)];
    
    // Add city name label
    self.cityNameLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 0, (self.screenWidth - 20), 40) ];
    self.cityNameLabel.textColor = [UIColor whiteColor];
    self.cityNameLabel.textAlignment = NSTextAlignmentCenter;
    self.cityNameLabel.text = [NSString stringWithFormat: @""];
    self.cityNameLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    [self.displayView addSubview:self.cityNameLabel];
    
    // Add region and country name label
    self.regionCountryNameLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 40, (self.screenWidth - 20), 20) ];
    self.regionCountryNameLabel.textColor = [UIColor whiteColor];
    self.regionCountryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.regionCountryNameLabel.text = [NSString stringWithFormat: @""];
    self.regionCountryNameLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [self.displayView addSubview:self.regionCountryNameLabel];
    
    // Add weather image label
    self.weatherImageLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(((self.screenWidth/2) - 25), 65, 52, 52) ];
    self.weatherImageLabel.backgroundColor = [UIColor clearColor];
    [self.displayView addSubview:self.weatherImageLabel];
    
    // Add weather description label
    self.weatherDescriptionLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 120, (self.screenWidth - 20), 20) ];
    self.weatherDescriptionLabel.textColor = [UIColor whiteColor];
    self.weatherDescriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.weatherDescriptionLabel.text = [NSString stringWithFormat: @""];
    self.weatherDescriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [self.displayView addSubview:self.weatherDescriptionLabel];
    
    // Add temperature label
    self.temperatureLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 140, (self.screenWidth - 20), 20) ];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.textAlignment = NSTextAlignmentCenter;
    self.temperatureLabel.text = [NSString stringWithFormat: @""];
    self.temperatureLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [self.displayView addSubview:self.temperatureLabel];
    
    // Add forecast title label
    self.forecastTitleLabel = [ [UILabel alloc ] initWithFrame:CGRectMake(10, 160, (self.screenWidth - 20), 20) ];
    self.forecastTitleLabel.textColor = [UIColor whiteColor];
    self.forecastTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.forecastTitleLabel.text = [NSString stringWithFormat: @""];
    self.forecastTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    [self.displayView addSubview:self.forecastTitleLabel];
    
    // Add forecast table
    self.weatherForecastTable = [NSMutableArray array];
    for(int rows = 0; rows < 6; rows++){
        for(int cols = 0; cols < 4; cols++){
            UILabel *label;
            if(cols == 0)
                label = [[UILabel alloc] initWithFrame:CGRectMake(10, (190 + (rows*20)), 60, 20) ];
            else if(cols == 1)
                label = [[UILabel alloc] initWithFrame:CGRectMake(70, (190 + (rows*20)), 140, 20) ];
            else if(cols == 2)
                label = [[UILabel alloc] initWithFrame:CGRectMake(210, (190 + (rows*20)), 50, 20) ];
            else if(cols == 3)
                label = [[UILabel alloc] initWithFrame:CGRectMake(260, (190 + (rows*20)), 50, 20) ];
            
            label.textAlignment = NSTextAlignmentCenter;
            [self.weatherForecastTable addObject:label];
            [self.displayView addSubview:label];
        }
    }
    
    // Add share current weather button
    self.shareCurrentWeatherButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareCurrentWeatherButton addTarget:self action:@selector(confirmShareCurrentWeather) forControlEvents:UIControlEventTouchDown];
    [self.shareCurrentWeatherButton setTitle:@"" forState:UIControlStateNormal];
    self.shareCurrentWeatherButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.shareCurrentWeatherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareCurrentWeatherButton.frame = CGRectMake(10, 330, (self.screenWidth - 20), 30);
    self.shareCurrentWeatherButton.enabled = NO;
    // Add the share current weather button to the display view
    [self.displayView addSubview:self.shareCurrentWeatherButton];
    
    // Add share weather forecast button
    self.shareWeatherForecastButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.shareWeatherForecastButton addTarget:self action:@selector(confirmShareWeatherForecast) forControlEvents:UIControlEventTouchDown];
    [self.shareWeatherForecastButton setTitle:@"" forState:UIControlStateNormal];
    self.shareWeatherForecastButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.shareWeatherForecastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareWeatherForecastButton.frame = CGRectMake(10, 360, (self.screenWidth - 20), 30);
    self.shareWeatherForecastButton.enabled = NO;
    // Add the share current weather button to the display view
    [self.displayView addSubview:self.shareWeatherForecastButton];
    
    // Add the display view to the main view
    [self.view addSubview:self.displayView];
}

-(void)buildControls
{
    // Add background image
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"bluesky.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Set up a view to add control components to
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.screenWidth, 100)];
    
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
    self.locationField.delegate = self;
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

- (bool)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(bool) isNumeric:(NSString*) checkText
{
	NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
	
	NSNumber* number = [numberFormatter numberFromString:checkText];
	
	if (number != nil) {
		NSLog(@"%@ is numeric", checkText);
		return true;
	}
	
	NSLog(@"%@ is not numeric", checkText);
    return false;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"Initializing display for screen of width: %f.", self.screenWidth);
    
	// Set up control interface
    [self buildControls];
    
    // Set up display interface
    [self buildForecast];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (!appDelegate.session.isOpen) {
        // create a fresh session object
        [FBSettings setDefaultAppID: @"557136654372374"];
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                //[self updateView];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
