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
}

