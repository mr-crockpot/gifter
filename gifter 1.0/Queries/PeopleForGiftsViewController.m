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
    _selectable = YES;
    if (_soloIncoming) {
        _selectable = NO;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    _selectable = YES;
}

-(void)loadData{
    NSString *loadGiftsQuery = @"SELECT * FROM gifts";
    _arrGifts = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:loadGiftsQuery]];
    
    
    NSString *loadPeopleOrderQuery;
    
    switch (_segmentDisplayMode) {
        case 0:
           loadPeopleOrderQuery =[NSString stringWithFormat: @"SELECT people.firstname, people.lastname, people.peopleID, ifnull (orders.gifts, -1) FROM people  JOIN orders ON people.peopleID = orders.people AND orders.gifts =  %li",_activeGift];
          
            break;
        case 1:
            loadPeopleOrderQuery =[NSString stringWithFormat: @"SELECT people.firstname, people.lastname, people.peopleID, ifnull (orders.gifts, -1) FROM people LEFT JOIN orders ON people.peopleID = orders.people AND orders.gifts =  %li",_activeGift];
        
            break;
        default:
            break;
    }
   
    _arrOrderPeopleJoin = [[NSMutableArray alloc] initWithArray:[_dbManager loadDataFromDB:loadPeopleOrderQuery]];
    [_tblViewPeople reloadData];
   
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tblViewPeople) {
        return _arrOrderPeopleJoin.count;
    }
    else if (tableView == _tblViewGifts) {
        if (!_activeGift) {
         return _arrGifts.count;
        }
        else{
            return 1;
        }
        }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
   if (tableView == _tblViewGifts) {
      UITableViewCell *cellGifts = [tableView dequeueReusableCellWithIdentifier:@"cellsGifts" forIndexPath:indexPath];
   
       if (!_activeGift) {
     
           cellGifts.textLabel.text = [NSString stringWithFormat:@"%@", _arrGifts[indexPath.row][1]];
           // [_arrGiftIDs addObject:_arrGifts[indexPath.row][0]];
     
 }
        else {
            cellGifts.textLabel.text = _arrGifts[_activeGift-1][1];
        }
        
        return  cellGifts;
    }
    
   else if (tableView == _tblViewPeople) {
       
    UITableViewCell *cellPeople = [tableView dequeueReusableCellWithIdentifier:@"cellsPeople" forIndexPath:indexPath];
    cellPeople.textLabel.text = [NSString stringWithFormat:@"%@ %@",_arrOrderPeopleJoin[indexPath.row][0],_arrOrderPeopleJoin[indexPath.row][1]];
       
     if ([_arrOrderPeopleJoin [indexPath.row][3] isEqualToString:@"-1"]) {
          cellPeople.accessoryType = UITableViewStylePlain;
           
       }
       
       else {
           
            cellPeople.accessoryType = UITableViewCellAccessoryCheckmark;
           
       }
       
    return cellPeople;
}
    return nil;
    }


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSString *peopleQuery;
    if (tableView == _tblViewGifts) {
       
        if (_selectable==YES) {
            
        _activeGift =[_arrGifts[indexPath.row][0] integerValue ];
       
        [self loadData];
        [_tblViewPeople reloadData];}
        
    }
    
    if (tableView == _tblViewPeople) {
        
        NSString *queryAdjustOrder;
        _activePerson = [_arrOrderPeopleJoin[indexPath.row][2] integerValue];
       

        if (![_arrOrderPeopleJoin[indexPath.row][3] isEqualToString:@"-1"]) {
           queryAdjustOrder = [NSString stringWithFormat:@"DELETE FROM orders WHERE people = %li and gifts = %li",_activePerson,_activeGift];
        }
        
        else {
           queryAdjustOrder = [NSString stringWithFormat: @"INSERT into orders values (null,%li,%li,0)",_activePerson,_activeGift];
        }
        
        [_dbManager executeQuery:queryAdjustOrder];
        [self loadData];
        [_tblViewPeople reloadData];
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"seguePeopleForGiftsToPeopleDetail"]) {
    //    PeopleDetailViewController *peopleDetailViewController = [segue destinationViewController];
    //    peopleDetailViewController.recordIDToEdit = [_arrPeopleIDs [_peopleRowSelected] intValue];
        
     
        
    }
}

- (IBAction)segmentPeopleListChanged:(UISegmentedControl*)segment {
    _segmentDisplayMode = segment.selectedSegmentIndex;
    [self loadData];
    [_tblViewPeople reloadData];
}
@end
