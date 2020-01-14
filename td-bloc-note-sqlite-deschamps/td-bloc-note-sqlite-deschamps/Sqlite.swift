//
//  Sqlite.swift
//  td-bloc-note-sqlite-deschamps
//
//  Created by local192 on 06/01/2020.
//  Copyright © 2020 local192. All rights reserved.
//

import Foundation
import SQLite3

class Sqlite {
    var dbPtr: OpaquePointer? = nil
    let sqlitePath: String
    let rowCount = 15
    
    init?(path: String) {
        sqlitePath = path
        dbPtr = self.openDatabase(path: sqlitePath)
    }
    
    func openDatabase(path: String) -> OpaquePointer{
        var connectdb: OpaquePointer? = nil
        var dbStatus: Int32 = SQLITE_ERROR
        
        dbStatus = sqlite3_open(path,&connectdb)
        if dbStatus != SQLITE_OK {
            print("Unable to open database. Erreur code:",dbStatus)
        }
        return connectdb!
    }
    
    func createTable(_ tableName: String, columnInfo: [String]) -> Int32{
        var dbStatus: Int32 = SQLITE_ERROR
        let sqlCmd: String = "create table if not exists \(tableName) "
            + "(\(columnInfo.joined(separator: ",")))"
        print(sqlCmd)
        dbStatus = sqlite3_exec(self.dbPtr, String(sqlCmd), nil, nil, nil)
        if dbStatus == SQLITE_OK {
            print("Create table success.")
        }
        return dbStatus
    }
    
    func insert(_ tableName: String, rowInfo: [String: String]) -> Int32 {
        var dbStatus: Int32 = SQLITE_ERROR
        
        let sqlCmd: String = "insert into \(tableName) "
            + "(\(rowInfo.keys.joined(separator: ",")))"
            + " values (\(rowInfo.values.joined(separator: ",")))"
        dbStatus = sqlite3_exec(self.dbPtr, String(sqlCmd), nil, nil, nil)
        if dbStatus == SQLITE_OK {
            print("Insert data success.")
        }else{
            print("Erreur")
        }
        return dbStatus
    }
    
    func fetch(_ tableName: String, cond: String?, sortBy order: String?, offset: Int?) -> OpaquePointer{
        var statement: OpaquePointer? = nil
        var dbStatus: Int32 = SQLITE_ERROR
        var sqlCmd: String = "select * from \(tableName)"
        
        if let condition = cond {
            sqlCmd += " where \(condition)"
        }
        
        if let orderby = order {
            sqlCmd += " order by \(orderby)"
        }
        
        sqlCmd += " limit \(rowCount)"
        
        if let offsetNum = offset {
            sqlCmd += " OFFSET \(offsetNum)"
        }
        
        print("fetch:",sqlCmd)
        
        dbStatus = sqlite3_prepare_v2(self.dbPtr, String(sqlCmd), -1,&statement, nil)
        print("Fetch data status:",dbStatus)
        return statement!
    }
    
    func update(_ tableName:String, cond:String?, rowInfo: [String : String]) -> Int32 {
        var statement: OpaquePointer? = nil
        var dbStatus: Int32 = SQLITE_ERROR
        

        
    }
    
    func delete(_  tableName:String, cond:String?) -> Int32 {
        var statement: OpaquePointer? = nil
        var dbStatus: Int32 = SQLITE_ERROR
        
        var sqlCmd: String = "delete from \(tableName) "
        // condition
        if let condition = cond {
            sqlCmd += " where \(condition)"
        }
        
        dbStatus = sqlite3_prepare_v2(self.dbPtr, String(sqlCmd), -1, &statement, nil)
        if dbStatus == SQLITE_OK && sqlite3_step(statement) == SQLITE_DONE {
            print("delete data success.")
            return dbStatus
        }
        sqlite3_finalize(statement)
        return dbStatus
    }
}

