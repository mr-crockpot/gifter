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
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    _pickerDate = [[UIDatePicker alloc] init];
    _df = [[NSDateFormatter alloc] init];
  
    [self loadEventsData];
    
    
    
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
    
    NSString *event = _arrEvents[row][1];
    return event;
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    _activeEvent = [_arrEvents[row][0] integerValue];
    _activeRow = row;
    // NSMutableArray *arraySlice = [[NSMutableArray alloc] initWithArray:_arrEvents[_activeRow] copyItems:YES];
    
    
    if ([_arrEvents[_activeRow][3] integerValue]!= -1) {
        _currentDate = _arrEvents[row][4];
        
    }
    else{
        _currentDate = nil;
        
    }
    _txtFieldDate.text = _currentDate;
}

- (IBAction)pickerDateValueChanged:(UIDatePicker*)sender {
    _df.dateFormat = @"MM dd yyyy";
    NSString *datePickedString = [_df stringFromDate:sender.date];
    _txtFieldDate.text = datePickedString;
    _activeDate = datePickedString;
    
    sender.datePickerMode = UIDatePickerModeTime;
    sender.datePickerMode = UIDatePickerModeDate;
    
    
    
}


 -(void)loadEventsData {
   

     NSString *queryJoinPeopleDates = [NSString stringWithFormat:@"SELECT events.eventID,events.eventName,events.repeats, ifnull( peopleDates.peopleID,-1),ifnull(peopledates.date, -1) FROM events LEFT JOIN peopleDates ON peopleDates.eventID = events.eventID AND peopleDates.peopleID = %li",_activePerson];
     
     _arrEvents = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryJoinPeopleDates]];
     
    
     
 }
 

 

- (IBAction)btnAddDatePressed:(id)sender {
    
   NSString *eventQuery;
    
    if ([_arrEvents[_activeRow][3] integerValue]!= -1) {
       
        eventQuery = [NSString stringWithFormat:@"update peopleDates set date = '%@' where peopleDates.eventID = %li and peopleDates.peopleID = %li",_activeDate,_activeEvent,_activePerson];
        
    }
    
    else {
      
        eventQuery = [NSString stringWithFormat:@"INSERT into peopleDates values (null,%li,%li,'%@')",_activePerson,_activeEvent,_activeDate];
        
    }
   [_dbManager executeQuery:eventQuery];
                    
    [self loadEventsData];
   
}
@end
