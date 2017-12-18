//
//  GiftsTableViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 12/5/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "GiftsTableViewController.h"
#import "GiftsDetailViewController.h"


@interface GiftsTableViewController ()

@end

@implementation GiftsTableViewController

- (void)viewDidLoad {
   

    
    
    _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated{
     [self.parentViewController.navigationItem setTitle:@"Gifts"];
    self.parentViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGifts)];
    
    [self loadData];

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
    return _arrGifts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    NSInteger indexOfGiftName = [_dbManager.arrColumnNames indexOfObject:@"giftname"];
    NSInteger indexOfPrice = [_dbManager.arrColumnNames indexOfObject:@"price"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[_arrGifts objectAtIndex:indexPath.row] objectAtIndex:indexOfGiftName]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[[_arrGifts objectAtIndex:indexPath.row] objectAtIndex:indexOfPrice]];
                                 
    return cell;
}

-(void)loadData{
    
    NSString *queryGifts =@"SELECT * FROM gifts";
    _arrGifts = [[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:queryGifts]];
  
    [_tblGifts reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     _recordIDToEdit = [[[_arrGifts objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    [self performSegueWithIdentifier:@"segueGiftsToGiftsDetail" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GiftsDetailViewController *giftDetailViewController = [segue destinationViewController];
    giftDetailViewController.recordIDToEdit = _recordIDToEdit;
    
}

-(void)addGifts{
    _recordIDToEdit = -1;
    [self performSegueWithIdentifier:@"segueGiftsToGiftsDetail" sender:self];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
