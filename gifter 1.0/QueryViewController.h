//
//  QueryViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 12/25/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface QueryViewController : UIViewController

@property (strong,nonatomic) DBManager *dbManager;
- (IBAction)btnQueryPressed:(id)sender;

@end
