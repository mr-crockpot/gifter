//
//  PeopleTableViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 11/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "PeopleDetailViewController.h"



@interface PeopleTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource/*,DetailViewControllerDelegate*/>

@property (nonatomic, strong) DBManager *dbManager;
-(void)loadData;

@property (strong, nonatomic) IBOutlet UITableView *tblPeople;
@property (strong, nonatomic) NSArray *arrPeople;

@property int recordIDToEdit;


@end
