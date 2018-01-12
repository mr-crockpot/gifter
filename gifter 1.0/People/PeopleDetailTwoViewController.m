//
//  PeopleDetailTwoViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 1/6/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "PeopleDetailTwoViewController.h"

@interface PeopleDetailTwoViewController ()

@end

@implementation PeopleDetailTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"dbGifter.db"];
    
    if (!_arrEvents) {
        
        _arrEvents =[[NSMutableArray alloc] initWithObjects:@"Christmas",@"Birthday",@"Anniversary",nil];
        
        
    }
    else{ [self loadEventsData];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _arrEvents.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *event = [_arrEvents objectAtIndex:row];
    return event;
    
}


- (IBAction)pickerDateValueChanged:(id)sender {
}

-(void)loadEventsData{
    
        NSString *queryEvents = @"SELECT * from EVENTS";
        _arrEvents = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryEvents]];
    
}
@end
