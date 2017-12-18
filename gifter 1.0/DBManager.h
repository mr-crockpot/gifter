//
//  DBManager.h
//  gifter 1.0
//
//  Created by Adam Schor on 11/25/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
-(instancetype)initWithDatabaseFilename:(NSString *)dbFileName;

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(void)copyDatabaseIntoDocumentsDirectory;


@property (nonatomic, strong) NSMutableArray *arrResults;
-(void)runQuery: (const char*)query isQueryExecutable: (BOOL)queryExectutable;


@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;


@end
