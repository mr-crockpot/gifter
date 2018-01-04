//
//  PeopleForGiftsViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 12/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "PeopleForGiftsViewController.h"
#import "PeopleDetailViewController.h"

@interface PeopleForGiftsViewController ()

@end

@implementation PeopleForGiftsViewController

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

-(void)loadData{
    NSString *loadGiftsQuery = @"SELECT * FROM gifts";
    _arrGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:loadGiftsQuery]];
    _arrGiftIDs = [[NSMutableArray alloc] init];
    _arrPeople = [[NSMutableArray alloc] init];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tblViewPeople) {
        return _arrPeople.count;
    }
    else if (tableView == _tblViewGifts) {
        return _arrGifts.count;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (tableView == _tblViewGifts) {
        
        UITableViewCell *cellGifts = [tableView dequeueReusableCellWithIdentifier:@"cellsGifts" forIndexPath:indexPath];
        cellGifts.textLabel.text = [NSString stringWithFormat:@"%@", _arrGifts[indexPath.row][1]];
         [_arrGiftIDs addObject:_arrGifts[indexPath.row][0]];
        
        return  cellGifts;
    }
    
    if (tableView == _tblViewPeople) {
        
    UITableViewCell *cellPeople = [tableView dequeueReusableCellWithIdentifier:@"cellsPeople" forIndexPath:indexPath];
   cellPeople.textLabel.text = [NSString stringWithFormat:@"%@",_arrPeople[indexPath.row][5]];
        [_arrPeopleIDs addObject:_arrPeople[indexPath.row][4]];
        
        return cellPeople;
    }
    
    
    else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *peopleQuery;
    if (tableView == _tblViewGifts) {
        _arrPeopleIDs = [[NSMutableArray alloc] init];
        NSInteger currentGiftID =[_arrGiftIDs[indexPath.row] integerValue];
        
        peopleQuery =[NSString stringWithFormat: @"SELECT * FROM orders JOIN people ON people = peopleID JOIN gifts on gifts = giftID WHERE gifts = %li",currentGiftID];
        
        _arrPeople = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:peopleQuery]];
        [_tblViewPeople reloadData];
    }
    
    if (tableView == _tblViewPeople) {
        _peopleRowSelected = indexPath.row;
       
       [self performSegueWithIdentifier:@"seguePeopleForGiftsToPeopleDetail" sender:self];
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"seguePeopleForGiftsToPeopleDetail"]) {
        PeopleDetailViewController *peopleDetailViewController = [segue destinationViewController];
        peopleDetailViewController.recordIDToEdit = [_arrPeopleIDs [_peopleRowSelected] intValue];
        
     
        
    }
}

@end
