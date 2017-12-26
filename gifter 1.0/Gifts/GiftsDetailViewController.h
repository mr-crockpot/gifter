//
//  GiftsDetailViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 12/5/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"




@interface GiftsDetailViewController : UIViewController <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>


@property (strong,nonatomic) DBManager *dbManager;

- (IBAction)saveInfo:(id)sender;

@property (strong,nonatomic) NSArray *arrPeople;
@property (strong, nonatomic) NSArray *arrOrders;
@property (strong, nonatomic) NSArray *arrIDs;


@property (nonatomic) int recordIDToEdit;

-(void)loadInfoToEdit;

@property (strong, nonatomic) IBOutlet UITextField *txtFieldGift;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldPrice;

@property (strong, nonatomic) NSMutableArray *arrSelectedRows;
@property (strong, nonatomic) NSMutableArray *arrActivePeople;

@property (strong, nonatomic) IBOutlet UIButton *btnViewDetail;

- (IBAction)btnViewDetailPressed:(id)sender;


@end
