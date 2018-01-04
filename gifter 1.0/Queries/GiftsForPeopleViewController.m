//
//  GiftsForPeopleViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 12/25/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "GiftsForPeopleViewController.h"
#import "GiftsDetailViewController.h"


@interface GiftsForPeopleViewController ()

@end

@implementation GiftsForPeopleViewController

- (void)viewDidLoad {
    
     _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    [self loadData];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData {
    NSString *loadPeopleQuery = @"SELECT * FROM people";
    _arrPeople = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:loadPeopleQuery]];
    _arrPeopleIDs = [[NSMutableArray alloc] init];
    _arrGifts = [[NSMutableArray alloc] init];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *giftQuery;
    
    if (tableView==_tblViewPeople) {
        _arrGiftIDs = [[NSMutableArray alloc] init];
        NSInteger currentPeopleID =[_arrPeopleIDs[indexPath.row] integerValue];
        
        giftQuery =[NSString stringWithFormat: @"SELECT * FROM orders JOIN people ON people = peopleID JOIN gifts on gifts = giftID WHERE people = %li",currentPeopleID];
        
        _arrGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:giftQuery]];
      
        [_tblViewGifts reloadData];
    }
    
    if (tableView == _tblViewGifts){
        _giftRowSelected = indexPath.row;
       
        [self performSegueWithIdentifier:@"segueGiftsForPeopleToGiftsDetails" sender:self];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tblViewPeople) {
        return _arrPeople.count;
    }
    else if (tableView == _tblViewGifts) {
        return _arrGifts.count;
    }
    return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tblViewPeople) {
        
    UITableViewCell *cellPeople = [tableView dequeueReusableCellWithIdentifier:@"cellsPeople" forIndexPath:indexPath];
        
    cellPeople.textLabel.text = [NSString stringWithFormat:@"%@", _arrPeople[indexPath.row][1]];
       
        [_arrPeopleIDs addObject:_arrPeople[indexPath.row][0]];
       
        return cellPeople;
    }
    else if (tableView == _tblViewGifts) {
        
        UITableViewCell *cellGifts = [tableView dequeueReusableCellWithIdentifier:@"cellsGifts" forIndexPath:indexPath];
        cellGifts.textLabel.text = [NSString stringWithFormat:@"%@", _arrGifts[indexPath.row][9]];
        [_arrGiftIDs addObject:_arrGifts[indexPath.row][8]];
       
        
        return cellGifts;
    }
    return nil;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueGiftsForPeopleToGiftsDetails"]) {
        GiftsDetailViewController *giftsDetailViewController = [segue destinationViewController];
        giftsDetailViewController.recordIDToEdit = [_arrGiftIDs[_giftRowSelected] intValue];
        
    }
}

@end
