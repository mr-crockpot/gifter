//
//  EventsTableViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 1/8/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"


@interface EventsTableViewController : UITableViewController

@property (strong, nonatomic) DBManager *dbManager;
@property (strong, nonatomic) NSMutableArray *arrEvents;

@property (strong, nonatomic) IBOutlet UITableView *tblViewEvents;

@property (strong, nonatomic) UIButton *btnFrequency;
@property (strong, nonatomic) NSString *btnFrequencyTitle;


@end
