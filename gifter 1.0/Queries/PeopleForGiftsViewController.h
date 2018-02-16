//
//  PeopleForGiftsViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 12/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@interface PeopleForGiftsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DBManager *dbManager;


@property NSInteger activeGift;
@property NSInteger activePerson;

@property (strong, nonatomic) IBOutlet UITableView *tblViewGifts;
@property (strong, nonatomic) IBOutlet UITableView *tblViewPeople;

//@property (strong, nonatomic) NSMutableArray *arrPeople;
//@property (strong, nonatomic) NSMutableArray *arrPeopleIDs;
//@property (strong, nonatomic) NSMutableArray *arrGiftIDs;
//@property (strong, nonatomic) NSMutableArray *arrOrders;

//these may be only ones that are needed. Erase above?

@property (strong, nonatomic) NSMutableArray *arrOrderPeopleJoin;
@property (strong, nonatomic) NSMutableArray *arrGifts;
@property BOOL selectable;
@property BOOL soloIncoming;

@property NSInteger peopleRowSelected;
@property NSInteger segmentDisplayMode;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentPeopleList;
- (IBAction)segmentPeopleListChanged:(id)sender;

@end
