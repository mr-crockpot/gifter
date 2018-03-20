//
//  PeopleDetailViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 11/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "PeopleDetailViewController.h"
#import "PeopleDetailTwoViewController.h"
#import "GiftsForPeopleViewController.h"
#import "DBManager.h"


@interface PeopleDetailViewController ()

@end

@implementation PeopleDetailViewController

- (void)viewDidLoad {
   
    _dbManager  = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    if (_recordIDToEdit != -1) {
        // Load the record with the specific ID from the database.
        [self loadInfoToEdit];
    }
    _datePickerBirthday = [[UIDatePicker alloc] init];
    _df = [[NSDateFormatter alloc] init];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [self loadInfoToEdit];
    [_tblViewEvents reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrEvents.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",_arrEvents[indexPath.row][0],_arrEvents[indexPath.row][1]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectedEvent = [_arrEvents[indexPath.row][2] integerValue];
    [self performSegueWithIdentifier:@"seguePeopleDetailToGiftsForPeople" sender:self];
    
}

- (IBAction)saveInfo:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
   if (self.recordIDToEdit == -1) {

       query = [NSString stringWithFormat:@"INSERT INTO people  VALUES (null, '%@', '%@',null,null,null,null,null,null)", _txtFieldFirstName.text, _txtFieldLastName.text];
       
    }
    else{
        query = [NSString stringWithFormat:@"UPDATE people SET firstname='%@', lastname='%@' where peopleID= %li", _txtFieldFirstName.text, _txtFieldLastName.text,  _recordIDToEdit];
    }

  // Execute the query.
    [self.dbManager executeQuery:query];
   
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished.
  //   [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }
    
    
}

-(void)loadInfoToEdit{
    // Create the query.
    NSString *queryPeople = [NSString stringWithFormat:@"SELECT * FROM people where peopleID=%li", _recordIDToEdit];
     NSString *queryEventsJoin = [NSString stringWithFormat: @"select events.eventName, peopleDates.date, events.eventID from peopleDates join events where peopleDates.eventID = events.eventID and peopleDates.peopleID = %li",_recordIDToEdit];
  
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPeople]];
    
    // Set the loaded data to the textfields.
    _txtFieldFirstName.text = [[results objectAtIndex:0] objectAtIndex:[_dbManager.arrColumnNames indexOfObject:@"firstname"]];
    _txtFieldLastName.text = [[results objectAtIndex:0] objectAtIndex:[_dbManager.arrColumnNames indexOfObject:@"lastname"]];
    
    
    NSString *dateToUse = _txtFieldBirthday.text;
   
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    df2.dateFormat = @"MM dd yyyy";
    
    NSDate *dateToSet = [df2 dateFromString:dateToUse];
   
 
    //  [_datePickerBirthday setDate:dateToSet];
    
    //Load the gifts tables
    
   // _arrGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPeople]];
    _arrEvents = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryEventsJoin]];
    
}


- (IBAction)datePickerBirthdayChanged:(UIDatePicker *)sender {
    
    _df.dateFormat = @"MM dd yyyy";
    NSString *datePickedString =[_df stringFromDate:sender.date];
 
    _txtFieldBirthday.text = datePickedString;
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
    if ([segue.identifier isEqualToString:@"seguePeopleDetailToPeopleDetailTwo"]) {
        
        PeopleDetailTwoViewController *peopleDetailTwoViewController = [segue destinationViewController];
        peopleDetailTwoViewController.activePerson = _recordIDToEdit;
    }
    
    if  ([segue.identifier isEqualToString:@"seguePeopleDetailToGiftsForPeople"]){
        GiftsForPeopleViewController *giftsForPeopleViewController = [segue destinationViewController];
        giftsForPeopleViewController.activePerson = _recordIDToEdit;
        giftsForPeopleViewController.soloIncoming = YES;
        giftsForPeopleViewController.activeEvent = _selectedEvent;
       
    }
    
}

@end
