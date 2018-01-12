//
//  PeopleDetailTwoViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 1/6/18.
//  Copyright © 2018 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface PeopleDetailTwoViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIDatePicker *pickerDate;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerEvent;
- (IBAction)pickerDateValueChanged:(id)sender;

@property (strong, nonatomic) NSMutableArray *arrEvents;

@property DBManager *dbManager;



@end
