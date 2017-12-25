//
//  PeopleDetailViewController.h
//  gifter 1.0
//
//  Created by Adam Schor on 11/26/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@protocol DetailViewControllerDelegate

-(void)editingInfoWasFinished;
@end

@interface PeopleDetailViewController : UIViewController <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtFieldFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldBirthday;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerBirthday;

- (IBAction)datePickerBirthdayChanged:(id)sender;

@property (strong, nonatomic) id<DetailViewControllerDelegate> delegate;

- (IBAction)saveInfo:(id)sender;

@property (strong,nonatomic) DBManager *dbManager;

@property (nonatomic) NSInteger recordIDToEdit;
-(void)loadInfoToEdit;

@property NSDateFormatter *df;



@end
