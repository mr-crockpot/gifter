//
//  EventsTableViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 1/8/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import "EventsTableViewController.h"

@interface EventsTableViewController ()

@end

@implementation EventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    [self loadEventsData];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.parentViewController.navigationItem setTitle:@"Event"];
    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arrEvents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
   
    cell.textLabel.text = _arrEvents [indexPath.row][1];
    NSInteger frequency = [_arrEvents[indexPath.row][2] integerValue];
   
    UISwitch *repeatSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(350, 10, 50, 50)];
    [cell.contentView addSubview:repeatSwitch];
    repeatSwitch.tag = indexPath.row;
    [repeatSwitch addTarget:self action:@selector(switchRepeat:) forControlEvents:UIControlEventValueChanged];
    
    [repeatSwitch setOn:frequency];
    
     cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}


-(IBAction)switchRepeat:(UISwitch*)sender{
   
    if ([_arrEvents[sender.tag][2] isEqualToString:@"1"]) {
        _arrEvents[sender.tag][2] = @"0";
        
    }
    
    else {
         _arrEvents[sender.tag][2] = @"1";
        
        
    }
  
    
    NSString *queryUpdate = [NSString stringWithFormat:@"UPDATE events SET repeats = %@ WHERE EventID = %li",_arrEvents[sender.tag][2],[_arrEvents[sender.tag][0] integerValue]];
        [_dbManager executeQuery:queryUpdate];
   
   
  
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

-(void)loadEventsData {
    NSString *queryEvents = @"SELECT * FROM events";
    _arrEvents = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:queryEvents]];
    NSLog (@"I load events data and the array is %@",_arrEvents);
   
    
}

-(void)createEventData{
    
    
    _arrEvents =[[NSMutableArray alloc] initWithObjects:@"Christmas",@"Birthday",@"Anniversary",nil];
    NSLog(@"The newly created arrEvents has %li items",_arrEvents.count);
    
    for  (int x = 0; x <_arrEvents.count; x++) {
        NSString *queryInsert = [NSString stringWithFormat:@"INSERT INTO events VALUES (null, '%@', '1')",_arrEvents[x]];
        [_dbManager executeQuery:queryInsert];
       
}
    [self loadEventsData];
}


-(void)addEvent{
    UIAlertController *addEventAlert = [UIAlertController alertControllerWithTitle:@"Add Event" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [addEventAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        }];
    
  
UIAlertAction *addEvent = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    
    NSString *newPreset = addEventAlert.textFields.firstObject.text;
   
    NSString *queryInsert = [NSString stringWithFormat:@"INSERT INTO events VALUES (null, '%@','1')",newPreset];
    [_dbManager executeQuery:queryInsert];
    [self loadEventsData];
    [_tblViewEvents reloadData];
    
    
}];

    [self presentViewController:addEventAlert animated:YES completion:nil];
    [addEventAlert addAction:addEvent];
  
    
}


@end
