//
//  PeopleDetailViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 11/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "PeopleDetailViewController.h"
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveInfo:(id)sender {
    // Prepare the query string.
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
    NSString *query;
   if (self.recordIDToEdit == -1) {

       query = [NSString stringWithFormat:@"INSERT INTO people  VALUES (null, '%@', '%@','%@')", _txtFieldFirstName.text, _txtFieldLastName.text, _txtFieldBirthday.text];
       
    }
    else{
        query = [NSString stringWithFormat:@"UPDATE people SET firstname='%@', lastname='%@', birthday='%@' where peopleID= %li", _txtFieldFirstName.text, _txtFieldLastName.text, _txtFieldBirthday.text, _recordIDToEdit];
    }

  // Execute the query.
    [self.dbManager executeQuery:query];
    NSLog(@"The query is %@",query);
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
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM people where peopleID=%li", _recordIDToEdit];
    NSLog(@"The number is %li", _recordIDToEdit);
    // Load the relevant data.
    NSArray *results = [[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the textfields.
    _txtFieldFirstName.text = [[results objectAtIndex:0] objectAtIndex:[_dbManager.arrColumnNames indexOfObject:@"firstname"]];
    _txtFieldLastName.text = [[results objectAtIndex:0] objectAtIndex:[_dbManager.arrColumnNames indexOfObject:@"lastname"]];
    _txtFieldBirthday.text = [[results objectAtIndex:0] objectAtIndex:[_dbManager.arrColumnNames indexOfObject:@"birthday"]];
    
    NSString *dateToUse = _txtFieldBirthday.text;
    NSLog(@"The date string is %@",dateToUse);
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    df2.dateFormat = @"MM dd yyyy";
    
    NSDate *dateToSet = [df2 dateFromString:dateToUse];
    NSLog(@"The NSDATE date is %@",dateToSet);
   // dateToSet = [_df dateFromString:@"12 10 2017"];
  //  NSLog(@"The date is %@",dateToSet);
  
      [_datePickerBirthday setDate:dateToSet];
    
}


- (IBAction)datePickerBirthdayChanged:(UIDatePicker *)sender {
    
    
    _df.dateFormat = @"MM dd yyyy";
    NSString *datePickedString =[_df stringFromDate:sender.date];
   NSLog(@"The date is %@", datePickedString);
    _txtFieldBirthday.text = datePickedString;
    NSLog(@"The date date is %@",[_df dateFromString:datePickedString]);
    
    
}
@end
