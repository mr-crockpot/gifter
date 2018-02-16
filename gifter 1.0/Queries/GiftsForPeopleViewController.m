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
    _selectable = YES;
    if (_soloIncoming) {
        _selectable = NO;
    }
    
    [self loadData];
    
    NSLog(@"selectabe is %i and active person is %li ",_selectable,_activePerson);
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
    
    NSString *loadGiftOrderQuery;
    switch (_segmentDisplayMode) {
        case 0:
            loadGiftOrderQuery = [NSString stringWithFormat:@"SELECT  gifts.giftname, gifts.giftID, ifnull (orders.people, -1) FROM gifts  JOIN orders ON gifts.giftID = orders.gifts AND orders.people = %li",_activePerson];
            break;
        case 1:
             loadGiftOrderQuery = [NSString stringWithFormat:@"SELECT  gifts.giftname, gifts.giftID, ifnull (orders.people, -1) FROM gifts  LEFT JOIN orders ON gifts.giftID = orders.gifts AND orders.people = %li",_activePerson];
            break;
        default:
            break;
    }
    
    _arrOrderGiftJoin = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:loadGiftOrderQuery]];
    [_tblViewGifts reloadData];
    
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tblViewPeople) {
        if (_activePerson == 0) {
            return _arrPeople.count;}
        else {
            return 1;
        }
    }
    if (tableView == _tblViewGifts) {
        return _arrOrderGiftJoin.count;
    }
    else{
    return 0;
    
}
}
    
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _tblViewPeople) {
        
        UITableViewCell *cellPeople = [tableView dequeueReusableCellWithIdentifier:@"cellsPeople" forIndexPath:indexPath];
        
        if (_activePerson == 0) {
        
    cellPeople.textLabel.text = [NSString stringWithFormat:@"%@", _arrPeople[indexPath.row][1]];
        }
        
        else {
            cellPeople.textLabel.text = [NSString stringWithFormat:@"%@ %@", _arrPeople[_activePerson-2][1],_arrPeople[_activePerson-2][2]];
            
        }
       
       
        return cellPeople;
    }
    else if (tableView == _tblViewGifts) {
        
        UITableViewCell *cellGifts = [tableView dequeueReusableCellWithIdentifier:@"cellsGifts" forIndexPath:indexPath];
        cellGifts.textLabel.text = _arrOrderGiftJoin[indexPath.row][0];
        
        if ([_arrOrderGiftJoin [indexPath.row][2] isEqualToString:@"-1"]) {
            cellGifts.accessoryType = UITableViewStylePlain;
            
        }
        
        else {
            
            cellGifts.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        
        return cellGifts;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==_tblViewPeople) {
        if (_selectable==YES) {
            
            _activePerson =[_arrPeople[indexPath.row][0] integerValue ];
            
            [self loadData];
         NSLog(@"People Active gift: %li Active Person:%li",_activeGift,_activePerson);
        [_tblViewGifts reloadData];
    }
    }
    
    if (tableView == _tblViewGifts){
        
        _activeGift = [_arrOrderGiftJoin[indexPath.row][1] integerValue];
        NSLog(@"Active gift: %li Active Person:_%li",_activeGift,_activePerson);
        
        NSString *queryAdjustOrder;
        if (![_arrOrderGiftJoin[indexPath.row][2] isEqualToString:@"-1"]) {
             NSLog(@"I am here");
            queryAdjustOrder = [NSString stringWithFormat:@"DELETE FROM orders WHERE people = %li and gifts = %li",_activePerson,_activeGift];
           
        }
    
        
        else {
            queryAdjustOrder = [NSString stringWithFormat:@"INSERT into orders values (null,%li,%li,0)",_activePerson,_activeGift];
            
        }
        
        [_dbManager executeQuery:queryAdjustOrder];
        [self loadData];
        [_tblViewGifts reloadData];
       ;
        
    }

}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"segueGiftsForPeopleToGiftsDetails"]) {
       // GiftsDetailViewController *giftsDetailViewController = [segue destinationViewController];
       // giftsDetailViewController.recordIDToEdit = [_arrGiftIDs[_giftRowSelected] intValue];
        
    }
}

- (IBAction)segmentGiftListChanged:(UISegmentedControl*)segment {
    _segmentDisplayMode = segment.selectedSegmentIndex;
    [self loadData];
    [_tblViewPeople reloadData];
}
@end
