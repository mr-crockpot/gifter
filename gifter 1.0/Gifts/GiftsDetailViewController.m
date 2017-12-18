//
//  GiftsDetailViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 12/5/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "GiftsDetailViewController.h"

@interface GiftsDetailViewController ()

@end

@implementation GiftsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _dbManager  = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    _arrSelectedRows =[[NSMutableArray alloc] init];
    [self loadInfoToEdit];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveInfo:(id)sender{
    // Prepare the query string.
  
    
    // If the recordIDToEdit property has value other than -1, then create an update query. Otherwise create an insert query.
#warning Placeholder
    _recordIDToEdit = 1;
    
    NSString *query;
    if (_recordIDToEdit == -1) {
        
        query = [NSString stringWithFormat:@"INSERT INTO gifts VALUES (null, '%@', %f)", _txtFieldGift.text, [_txtFieldPrice.text floatValue]];
        
        
    }
    else{
        query = [NSString stringWithFormat:@"UPDATE gifts SET giftname='%@', price=%li where giftID= %d", _txtFieldGift.text,[ _txtFieldPrice.text integerValue], _recordIDToEdit];
    }
    
    // Execute the query.
    [_dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (_dbManager.affectedRows != 0) {
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
    NSString *queryPeople = @"SELECT * FROM people";
    _arrPeople =[[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPeople]];
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrPeople.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
  //  NSInteger indexOfFirstName = [_dbManager.arrColumnNames indexOfObject:@"firstname"];
   // NSInteger indexOfLastName = [_dbManager.arrColumnNames indexOfObject:@"lastname"];
  
    NSInteger indexOfFirstName = 1;
    NSInteger indexOfLastName =  2;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[_arrPeople objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstName],[[_arrPeople objectAtIndex:indexPath.row] objectAtIndex:indexOfLastName]];
  
    if ([_arrSelectedRows containsObject:[NSString stringWithFormat:@"%li",indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor redColor];
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *personID = _arrPeople [indexPath.row][0];
    
    if ([_arrSelectedRows containsObject:[NSString stringWithFormat:@"%li",indexPath.row]]) {
        [_arrSelectedRows removeObject:[NSString stringWithFormat:@"%li",indexPath.row]];
        [self deleteOder:[personID integerValue] giftID:_recordIDToEdit];
    }
    else{
        [_arrSelectedRows addObject:[NSString stringWithFormat:@"%li",indexPath.row]];
        [self addOrder:[personID integerValue] giftID:_recordIDToEdit];
    }
    
    [tableView reloadData];
   
    
}
-(void)addOrder: (NSInteger)personID giftID: (NSInteger) giftID{
  
    NSString *queryOrder = [NSString stringWithFormat: @"INSERT INTO orders VALUES (null, %li, %li,0)",personID,giftID];
    [_dbManager executeQuery:queryOrder];
}

-(void)deleteOder: (NSInteger)personID giftID: (NSInteger)giftID {
    NSString *queryDeleteOrder = [NSString stringWithFormat:@"DELETE FROM orders WHERE people = %li AND gifts = %li",personID,giftID ];
    [_dbManager executeQuery:queryDeleteOrder];
    
    
}




@end
