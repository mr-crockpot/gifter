//
//  QueryViewController.m
//  gifter 1.0
//
//  Created by Adam Schor on 12/25/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "QueryViewController.h"


@interface QueryViewController ()

@end

@implementation QueryViewController

- (void)viewDidLoad {
     _dbManager = [[DBManager alloc] initWithDatabaseFilename:@"gifterDB.db"];
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)btnQueryPressed:(id)sender {
    
    NSString *query = @"SELECT * FROM orders JOIN people ON people = peopleID JOIN gifts on gifts = giftID WHERE people = '2' ";
    NSArray *arrGifts = [[NSArray alloc] initWithArray:[_dbManager loadDataFromDB:query]];
    NSLog(@"The array is %@",arrGifts);
    NSLog(@"The gift is %@ and the person is %@",arrGifts[0][9],arrGifts[0][5]);
    
    
    
    
}
@end
