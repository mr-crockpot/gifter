//
//  DBManager.m
//  gifter 1.0
//
//  Created by Adam Schor on 11/25/17.
//  Copyright © 2017 AandA Development. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

-(DBManager *)initWithDatabaseFilename:(NSString *)dbFilename {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [paths objectAtIndex:0];
    
    _databaseFilename = dbFilename;
    [self copyDatabaseIntoDocumentsDirectory];
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory {
    NSString *destinationPath = [_documentsDirectory stringByAppendingPathComponent:_databaseFilename];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:destinationPath]) {
        NSString *sourcePath = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:_databaseFilename];
        [[NSFileManager defaultManager]copyItemAtPath:sourcePath toPath:destinationPath error:nil];
        
    }
    
    
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExectutable {
    //create a sqLite object
    
    sqlite3 *sqlite3Database;
    
    //Set the database file path
    NSString *databasePath = [_documentsDirectory stringByAppendingPathComponent:_databaseFilename];
    //Initialize the results array
    if (_arrResults!=nil) {
        
        [_arrResults removeAllObjects];
        _arrResults = nil;
        
    }
    _arrResults = [[NSMutableArray alloc]init];
    //Initials the column names array
    
    if (_arrColumnNames != nil) {
        [_arrColumnNames removeAllObjects];
        _arrColumnNames = nil;
    }
    _arrColumnNames = [[NSMutableArray alloc] init];
    
    //Open the database
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    if (openDatabaseResult == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {
            if (!queryExectutable) {
                NSMutableArray *arrDataRow;
                
                while (sqlite3_step(compiledStatement)== SQLITE_ROW) {
                    
                    arrDataRow = [[NSMutableArray alloc] init];
                    int totalColumns =sqlite3_column_count(compiledStatement);
                    
                    for (int i =0; i<totalColumns; i++) {
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement,i);
                        
                        if (dbDataAsChars != NULL) {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        if (_arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement,i);
                            [_arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                            
                        }
                    }
                    if (arrDataRow.count>0) {
                        [_arrResults addObject:arrDataRow];
                    }
                }
            }
            else {
                //changed BOOL to int
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    _affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    _lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
        
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
}



-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)_arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
