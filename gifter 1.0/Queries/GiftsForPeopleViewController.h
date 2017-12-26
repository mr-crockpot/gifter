//
//  GiftsForPeopleViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 12/25/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@interface GiftsForPeopleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong,nonatomic)  DBManager *dbManager;

@property (strong, nonatomic) IBOutlet UITableView *tblViewPeople;
@property (strong, nonatomic) IBOutlet UITableView *tblViewGifts;

@property (strong, nonatomic) NSMutableArray *arrPeople;
@property (strong, nonatomic) NSMutableArray *arrGifts;
@property (strong, nonatomic) NSMutableArray *arrPeopleIDs;
@property (strong, nonatomic) NSMutableArray *arrGiftIDs;

@property NSInteger giftRowSelected;



@end
