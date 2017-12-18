//
//  GiftsTableViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 12/5/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface GiftsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, strong) DBManager *dbManager;
-(void)loadData;

@property (strong, nonatomic) IBOutlet UITableView *tblGifts;
@property (strong, nonatomic) NSArray *arrGifts;

@property int recordIDToEdit;


@end
