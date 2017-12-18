//
//  PeopleTableViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 11/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "PeopleTableViewController.h"
#import "PeopleDetailViewController.h"


@interface PeopleTableViewController ()

@end

@implementation PeopleTableViewController

- (void)viewDidLoad {
    
    
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
   // [self loadData];
    
    
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.parentViewController.navigationItem setTitle:@"People"];
    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPeople)];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
// Form the query.
NSString *queryPeople = @"SELECT * FROM people";
// Get the results.
if (_arrPeople != nil) {
    _arrPeople = nil;
                      }
_arrPeople = [[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:queryPeople]];
    
// Reload the table view.
[_tblPeople reloadData];
    


}

-(void)addPeople {
    _recordIDToEdit = -1;
    [self performSegueWithIdentifier:@"seguePeopleToPeopleDetail" sender:self];
    
}
                  
                  
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrPeople.count;
}

                  
                  

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
   NSInteger indexOfFirstName = [_dbManager.arrColumnNames indexOfObject:@"firstname"];
    NSInteger indexOfLastName = [_dbManager.arrColumnNames indexOfObject:@"lastname"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[_arrPeople objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstName],[[_arrPeople objectAtIndex:indexPath.row] objectAtIndex:indexOfLastName]];
  
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     _recordIDToEdit = [[[_arrPeople objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"seguePeopleToPeopleDetail" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    PeopleDetailViewController *peopleDetailViewController = [segue destinationViewController];
   // peopleDetailViewController.delegate = self;
    peopleDetailViewController.recordIDToEdit = _recordIDToEdit;
    
    

    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        int recordIDToDelete = [[[_arrPeople objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        NSString *query =[NSString stringWithFormat:@"DELETE FROM people WHERE peopleID = %d",recordIDToDelete];
        
        [_dbManager executeQuery:query];
        [self loadData];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
